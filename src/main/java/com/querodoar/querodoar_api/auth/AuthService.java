// TODO: KSG: Acredito que IAM (Identity and Access Management) seria um nome mais apropriado para essa classe

package com.querodoar.querodoar_api.auth;

import com.querodoar.querodoar_api.address.Address;
import com.querodoar.querodoar_api.address.AddressService;
import com.querodoar.querodoar_api.address.dtos.AddressCreateDto;
import com.querodoar.querodoar_api.auth.dtos.LoginDto;
import com.querodoar.querodoar_api.auth.dtos.ResetPasswordDto;
import com.querodoar.querodoar_api.exceptions.UnauthorizedException;
import com.querodoar.querodoar_api.usuario.User;
import com.querodoar.querodoar_api.usuario.UserService;
import com.querodoar.querodoar_api.usuario.dtos.UserCreateDto;
import com.querodoar.querodoar_api.usuario.dtos.UserCreateMinimalDto;
import com.querodoar.querodoar_api.usuario.entity.UserToken;
import com.querodoar.querodoar_api.utils.JwtUtil;
import com.querodoar.querodoar_api.utils.StringUtil;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;

@Service
public class AuthService {
    @Autowired
    private UserService userService;

    @Autowired
    private AddressService addressService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User create(UserCreateDto dto){
        return this.userService.create(dto, null);
    }

    public User create(UserCreateMinimalDto dto){
        return this.userService.create(dto);
    }

    public Address createAddress(AddressCreateDto dto){
        return this.addressService.create(dto);
    }

    public String login(LoginDto dto){
        User usuario  = this.userService.findByEmail(dto.getEmail());
        Boolean match = this.userService.compararSenha(dto.getPassword_hash(), usuario);

        if(!match)
            throw new UnauthorizedException("Credenciais inválidas");

        if(!usuario.getVerified())
            throw new UnauthorizedException("Usuário não verificado");

        if(!usuario.getActive())
            throw new UnauthorizedException("Usuário inativo");

        return jwtUtil.gerar(usuario.getId(), usuario.getRole());
    }

    public UserToken createUserToken(char type, User user){
        UserToken token = new UserToken();
        token.setUser(user);
        token.setCreatedAt(OffsetDateTime.now());
        token.setExpiresAt(OffsetDateTime.now().plusHours(1));
        token.setType(type);
        String seed = user.getEmail() + System.currentTimeMillis();
        token.setToken(StringUtil.secureRandomString());
        return this.userService.saveUserToken(token);
    }

    @Transactional
    public boolean validateUserToken(String token, char type) {
        UserToken userToken = this.userService.findUserTokenByToken(token);
        if (userToken == null) {
            return false; // Token não encontrado
        }
        if (userToken.getConfirmedAt() != null) {
            return false; // Já foi confirmado
        }
        if (userToken.getExpiresAt().isBefore(OffsetDateTime.now())) {
            return false; // Expirado
        }
        if(userToken.getType() != type) {
            return false; // Tipo inválido
        }

        //Define a data de confirmação
        userToken.setConfirmedAt(OffsetDateTime.now());

        // Marca o usuário como verificado
        userToken.getUser().setVerified(true);

        return true;
    }

    public User findUserByEmail(String email) {
        return this.userService.findByEmail(email);
    }

    @Transactional
    public User resetPassword(ResetPasswordDto dto) {
        UserToken userToken = this.userService.findUserTokenByToken(dto.getToken());
        User user = userToken.getUser();
        user.setPasswordHash(this.passwordEncoder.encode(dto.getNewPassword()));
        return user;
    }

    @Transactional
    public User findUserByUserToken(String token) {
        UserToken userToken = this.userService.findUserTokenByToken(token);
        if (userToken == null) {
            return null;
        }
        return userToken.getUser();
    }
}
