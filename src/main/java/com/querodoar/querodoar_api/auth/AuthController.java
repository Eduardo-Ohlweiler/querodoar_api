package com.querodoar.querodoar_api.auth;

import com.querodoar.querodoar_api.address.Address;
import com.querodoar.querodoar_api.address.dtos.AddressCreateDto;
import com.querodoar.querodoar_api.auth.dtos.LoginDto;
import com.querodoar.querodoar_api.email.EmailService;
import com.querodoar.querodoar_api.exceptions.dto.ExceptionResponseDto;
import com.querodoar.querodoar_api.usuario.Role;
import com.querodoar.querodoar_api.usuario.User;
import com.querodoar.querodoar_api.usuario.dtos.UserCreateDto;
import com.querodoar.querodoar_api.usuario.dtos.UserCreateMinimalDto;
import com.querodoar.querodoar_api.usuario.entity.UserToken;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.mail.MessagingException;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.OffsetDateTime;

@RestController
@RequestMapping("/api/auth")
@Tag(name = "Auth", description = "Operações relacionadas a autenticação, como cadastros de usuários comuns e login")
public class AuthController {

    @Autowired
    private AuthService service;

    @Autowired
    private EmailService emailService;

    @Operation(
            summary = "Cria um novo usuário comum",
            description = "Cria um novo usuário comum no sistema com base nos dados fornecidos.",
            responses = {
                @ApiResponse(responseCode = "201", description = "Usuário criado com sucesso",
                        content = @Content(schema = @Schema(implementation = User.class))),
                @ApiResponse(responseCode = "409", description = "Usuário já existe",
                        content = @Content(schema = @Schema(implementation = ExceptionResponseDto.class))),
                @ApiResponse(responseCode = "400", description = "Dados inválidos",
                        content = @Content(schema = @Schema(implementation = ExceptionResponseDto.class)))
            }
    )
    @PostMapping("/create")
    public ResponseEntity<User> create(@Valid @RequestBody UserCreateDto dto) {
        User user = this.service.create(dto);
        return new ResponseEntity<>(user, HttpStatus.CREATED);
    }

    @Operation(
        summary = "Cria um novo endereço",
        description = "Cria um novo endereço associado a um usuário ou cidade.",
        responses = {
                @ApiResponse(responseCode = "201", description = "Endereço criado com sucesso",
                        content = @Content(schema = @Schema(implementation = Address.class))),
                @ApiResponse(responseCode = "400", description = "Dados inválidos",
                        content = @Content(schema = @Schema(implementation = ExceptionResponseDto.class)))
            }
    )
    @PostMapping("/createaddress")
    public ResponseEntity<Address> createAddress(@Valid @RequestBody AddressCreateDto dto){
        Address address = this.service.createAddress(dto);
        return new ResponseEntity<>(address, HttpStatus.CREATED);
    }

    @Operation(summary = "Faz login")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Login realizado com sucesso"),
            @ApiResponse(responseCode = "401", description = "Não autorizado")
    })
    @PostMapping("/login")
    public ResponseEntity<String> login(@Valid @RequestBody LoginDto dto){
        String temp = this.service.login(dto);
        return new ResponseEntity<>(temp, HttpStatus.OK);
    }

    // TODO: Implementar as validações para os demais responses
    @Operation(
            summary = "Cria um novo usuário comum com dados mínimos e envia email de verificação",
            description = "Cria um novo usuário comum no sistema com base nos dados mínimos fornecidos e envia um email de verificação.",
            responses = {
                @ApiResponse(responseCode = "201", description = "Usuário criado com sucesso e email de verificação enviado",
                        content = @Content(schema = @Schema(implementation = User.class))),
                @ApiResponse(responseCode = "409", description = "Usuário já existe",
                        content = @Content(schema = @Schema(implementation = ExceptionResponseDto.class))),
                @ApiResponse(responseCode = "400", description = "Dados inválidos",
                        content = @Content(schema = @Schema(implementation = ExceptionResponseDto.class))),
                @ApiResponse(responseCode = "500", description = "Erro ao enviar email",
                        content = @Content(schema = @Schema(implementation = ExceptionResponseDto.class)))
            }
    )
    @PostMapping("/user/create")
    public ResponseEntity<HttpStatus> createUser(@Valid @RequestBody UserCreateMinimalDto dto) throws MessagingException {
        User user = this.service.create(dto);
        UserToken token = this.service.createUserToken('A', user);
        emailService.sendVerificationEmail(user.getEmail(), token.getToken());
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
}
