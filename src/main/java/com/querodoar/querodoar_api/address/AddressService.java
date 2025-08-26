package com.querodoar.querodoar_api.address;

import com.querodoar.querodoar_api.address.dtos.AddressCreateDto;
import com.querodoar.querodoar_api.city.City;
import com.querodoar.querodoar_api.city.CityRepository;
import com.querodoar.querodoar_api.exceptions.NotFoundException;
import com.querodoar.querodoar_api.usuario.User;
import com.querodoar.querodoar_api.usuario.UserRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.Optional;

@Service
public class AddressService {

    @Autowired
    private AddressRepository repository;

    @Autowired
    private CityRepository cityRepository;

    @Autowired
    private UserRepository userRepository;

    public Address findByUserId(Integer userId){
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("Usuário não encontrado com ID: " + userId));

        Address address = user.getAddress();
        if(address == null)
            throw new NotFoundException("Nenhum endereço encontrado");

        return address;
    }

    public Address findById(Integer id) throws NotFoundException {
        Optional<Address> address = this.repository.findById(id);
        if(address.isEmpty())
            throw new NotFoundException("Endereço não encontrado");

        return address.get();
    }

    public Address create(AddressCreateDto dto){
        try {
            Address address = new Address();
            if(dto.getCityId() != null){
                City city = cityRepository.findById(dto.getCityId())
                        .orElseThrow(() -> new NotFoundException("Cidade não encontrada"));

                address.setCity(city);
            }
            if (dto.getComplement() != null && !dto.getComplement().isEmpty()) {
                address.setComplement(dto.getComplement());
            }

            if (dto.getReference() != null && !dto.getReference().isEmpty()) {
                address.setReference(dto.getReference());
            }
            address.setNeighborhood(dto.getNeighborhood());
            address.setNumber(dto.getNumber());
            address.setPostalCode(dto.getPostalCode());
            address.setStreet(dto.getStreet());

            this.repository.save(address);
            return address;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
