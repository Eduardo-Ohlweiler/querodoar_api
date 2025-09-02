package com.querodoar.querodoar_api.usuario;

import com.querodoar.querodoar_api.exceptions.UnauthorizedException;
import com.querodoar.querodoar_api.usuario.dtos.UserCreateDto;
import com.querodoar.querodoar_api.usuario.dtos.UserUpdateDto;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user")
@Tag(name = "Usuário", description = "Operações relacionadas aos usuários do sistema")
public class UserController {
    @Autowired
    private UserService service;

    @Operation(summary = "Lista todos os usuários")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Lista retornada com sucesso"),
            @ApiResponse(responseCode = "401", description = "Não autorizado")
    })
    @GetMapping
    public ResponseEntity<Page<User>> getAll(Pageable pageable){
        Page<User> usuarios = this.service.getAll(pageable);
        return new ResponseEntity<>(usuarios, HttpStatus.OK);
    }

    @Operation(summary = "Cria um novo usuário, rota disponivel apenas para usuarios administrativos")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Usuário criado com sucesso"),
        @ApiResponse(responseCode = "400", description = "Dados inválidos"),
        @ApiResponse(responseCode = "409", description = "Email ou CPF já cadastrado")
    })
    @PostMapping("/create")
    public ResponseEntity<User> create(@Valid @RequestBody UserCreateDto dto, Authentication auth) {
        Integer usuarioId = (Integer) auth.getPrincipal();
        User usuarioLogado = service.findById(usuarioId);
        if(usuarioLogado.getRole() != Role.ADMIN)
            throw new UnauthorizedException("Acesso negado: apenas administradores podem criar usuários");

        User usuario = this.service.create(dto, usuarioId);
        return new ResponseEntity<>(usuario, HttpStatus.CREATED);
    }

    @Operation(summary  = "Delete de usuarios por id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Usuario deletado com sucesso"),
            @ApiResponse(responseCode = "401", description = "Não autorizado")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<HttpStatus> delete(@PathVariable int id, Authentication auth){
        Integer usuarioId     = (Integer) auth.getPrincipal();
        User usuarioLogado = service.findById(usuarioId);
        if(usuarioLogado.getRole() != Role.ADMIN)
            throw new UnauthorizedException("Acesso negado: apenas administradores podem deletar usuários");

        this.service.delete(id, usuarioLogado);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Operation(summary = "Atualiza um usuario por id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Atualizado com sucesso"),
            @ApiResponse(responseCode = "401", description = "Não autorizado")
    })
    @PatchMapping("/{id}")
    public ResponseEntity<User> update(@PathVariable Integer id, @Valid @RequestBody UserUpdateDto dto, Authentication auth){
        Integer usuarioId = (Integer) auth.getPrincipal();
        User usuario      = this.service.update(id, dto, usuarioId);
        return new ResponseEntity<>(usuario, HttpStatus.OK);
    }
}
