package com.querodoar.querodoar_api.auth;

import com.querodoar.querodoar_api.address.Address;
import com.querodoar.querodoar_api.address.dtos.AddressCreateDto;
import com.querodoar.querodoar_api.exceptions.dto.ExceptionResponseDto;
import com.querodoar.querodoar_api.usuario.User;
import com.querodoar.querodoar_api.usuario.dtos.UserCreateDto;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
@Tag(name = "Auth", description = "Operações relacionadas a autenticação, como cadastros de usuários comuns e login")
public class AuthController {

    @Autowired
    private AuthService service;

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

        User usuario = this.service.create(dto);
        return new ResponseEntity<>(usuario, HttpStatus.CREATED);
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
}
