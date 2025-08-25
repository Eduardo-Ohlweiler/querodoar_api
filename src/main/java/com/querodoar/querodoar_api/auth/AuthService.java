package com.querodoar.querodoar_api.auth;

import com.querodoar.querodoar_api.address.Address;
import com.querodoar.querodoar_api.address.AddressService;
import com.querodoar.querodoar_api.address.dtos.AddressCreateDto;
import com.querodoar.querodoar_api.usuario.User;
import com.querodoar.querodoar_api.usuario.UserService;
import com.querodoar.querodoar_api.usuario.dtos.UserCreateDto;
import com.querodoar.querodoar_api.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AuthService {
    @Autowired
    private UserService userService;

    @Autowired
    private AddressService addressService;

    @Autowired
    private JwtUtil jwtUtil;

    public User create(UserCreateDto dto){
        return this.userService.create(dto, null);
    }

    public Address createAddress(AddressCreateDto dto){
        return this.addressService.create(dto);
    }
}
