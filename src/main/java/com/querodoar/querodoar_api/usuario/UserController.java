package com.querodoar.querodoar_api.usuario;

import com.querodoar.querodoar_api.usuario.dtos.UserCreateDto;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user")
public class UserController {
    @Autowired
    private UserService service;

    @GetMapping
    public ResponseEntity<List<User>> getAll(){
        List<User> usuarios = this.service.getAll();
        return new ResponseEntity<>(usuarios, HttpStatus.OK);
    }

    @PostMapping("/create")
    public ResponseEntity<User> create(@Valid @RequestBody UserCreateDto dto, Authentication auth) {
        Integer usuarioId = (Integer) auth.getPrincipal();

        User usuario = this.service.create(dto, usuarioId);
        return new ResponseEntity<>(usuario, HttpStatus.CREATED);
    }
}
