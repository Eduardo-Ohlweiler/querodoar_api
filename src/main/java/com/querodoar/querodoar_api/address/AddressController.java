package com.querodoar.querodoar_api.address;

import com.querodoar.querodoar_api.address.dtos.AddressCreateDto;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/address")
@Tag(name = "Endereço", description = "Operações relacionadas ao cadastro de endereços")
public class AddressController {

    @Autowired
    private AddressService service;

    @GetMapping("/address/{userId}")
    public ResponseEntity<Address> findByUserId(@PathVariable Integer userId){
        Address address = service.findByUserId(userId);
        return new ResponseEntity<>(address, HttpStatus.OK);
    }

    public ResponseEntity<Address> findById(@PathVariable Integer addressId){
        Address address = this.service.findById(addressId);

        return new ResponseEntity<>(address, HttpStatus.OK);
    }

    @Operation(summary = "Cria um novo endereço")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Endereço criado com sucesso"),
            @ApiResponse(responseCode = "400", description = "Dados inválidos"),
    })
    @PostMapping
    public ResponseEntity<Address> create(@Valid @RequestBody AddressCreateDto dto){
        Address address = this.service.create(dto);
        return new ResponseEntity<>(address, HttpStatus.CREATED);
    }

}
