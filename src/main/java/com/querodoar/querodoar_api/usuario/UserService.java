package com.querodoar.querodoar_api.usuario;

import com.querodoar.querodoar_api.exceptions.ConflictException;
import com.querodoar.querodoar_api.exceptions.NotFoundException;
import com.querodoar.querodoar_api.usuario.dtos.UserCreateDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    @Autowired
    private UserRepository repository;
    private PasswordEncoder passwordEncoder;

    public List<User> getAll(){
        return this.repository.findAll();
    }

    public User findByEmail(String email) throws NotFoundException {
        Optional<User> usuario = this.repository.findByEmail(email);
        if(usuario.isEmpty())
            throw new NotFoundException("Usuario não encontrado");

        return usuario.get();
    }

    public User findById(Integer id) throws NotFoundException{
        Optional<User> usuario = this.repository.findById(id);
        if(usuario.isEmpty())
            throw new NotFoundException("Usuario não encontrado");

        return usuario.get();
    }

    public User create(UserCreateDto dto, Integer usuarioId){
        boolean usuario_existe = this.repository.existsByEmail(dto.getEmail());
        if(usuario_existe)
            throw new ConflictException("Já existe usuario com esse email cadastrado, verifique");

        User usuario = new User();
        usuario.setName(dto.getName());
        usuario.setEmail(dto.getEmail());
        usuario.setCpf(dto.getCpf());
        usuario.setBirthday(dto.getBirthday());
        usuario.setPasswordHash(passwordEncoder.encode(dto.getPassword_hash()));

        if(usuarioId != null){
            User usuario_logado = this.findById(usuarioId);
            if(usuario_logado != null){
                if(usuario_logado.getRole() == Role.ADMIN){
                    usuario.setRole(dto.getRole());
                }
            }
        }
        this.repository.save(usuario);
        usuario.setPasswordHash(null);
        return usuario;
    }
}
