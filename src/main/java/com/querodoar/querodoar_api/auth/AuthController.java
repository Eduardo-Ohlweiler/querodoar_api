package com.querodoar.querodoar_api.auth;

import com.querodoar.querodoar_api.usuario.User;
import com.querodoar.querodoar_api.usuario.dtos.UserCreateDto;
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
public class AuthController {

    @Autowired
    private AuthService service;

    @PostMapping("/create")
    public ResponseEntity<User> create(@Valid @RequestBody UserCreateDto dto) {

        User usuario = this.service.create(dto);
        return new ResponseEntity<>(usuario, HttpStatus.CREATED);
    }
}
