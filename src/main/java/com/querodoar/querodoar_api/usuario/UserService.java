package com.querodoar.querodoar_api.usuario;

import com.querodoar.querodoar_api.address.Address;
import com.querodoar.querodoar_api.address.AddressRepository;
import com.querodoar.querodoar_api.address.dtos.AddressCreateDto;
import com.querodoar.querodoar_api.city.City;
import com.querodoar.querodoar_api.city.CityRepository;
import com.querodoar.querodoar_api.exceptions.ConflictException;
import com.querodoar.querodoar_api.exceptions.NotFoundException;
import com.querodoar.querodoar_api.exceptions.UnauthorizedException;
import com.querodoar.querodoar_api.usuario.dtos.UserCreateDto;
import com.querodoar.querodoar_api.usuario.dtos.UserUpdateDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {
    @Autowired
    private UserRepository repository;

    @Autowired
    private AddressRepository addressRepository;

    @Autowired
    private CityRepository cityRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public Page<User> getAll(Pageable pageable){
        return this.repository.findAll(pageable);
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
        if(repository.existsByCpf(dto.getCpf()))
            throw new ConflictException("CPF já cadastrado");

        User usuario = new User();
        usuario.setName(dto.getName());
        usuario.setEmail(dto.getEmail());
        usuario.setCpf(dto.getCpf());
        usuario.setBirthday(dto.getBirthday());
        usuario.setCellPhone(dto.getCell_phone());
        usuario.setHomePhone(dto.getHome_phone());
        usuario.setWhatsapp(dto.getWhatsapp());
        usuario.setPasswordHash(passwordEncoder.encode(dto.getPassword_hash()));

        // Cria address se vier no DTO
        if (dto.getAddress() != null) {
            AddressCreateDto addrDto = dto.getAddress();
            Address address = new Address();

            // Associa cidade existente
            City city = cityRepository.findById(addrDto.getCityId())
                    .orElseThrow(() -> new NotFoundException("Cidade não encontrada"));
            address.setCity(city);

            address.setPostalCode(addrDto.getPostalCode());
            address.setStreet(addrDto.getStreet());
            address.setNumber(addrDto.getNumber());
            address.setNeighborhood(addrDto.getNeighborhood());
            address.setComplement(addrDto.getComplement());
            address.setReference(addrDto.getReference());

            addressRepository.save(address);
            usuario.setAddress(address);
        }

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

    public User update(Integer id, UserUpdateDto dto, Integer usuarioId){
        if(usuarioId == null)
            throw new UnauthorizedException("Acesso negado: Apenas usuarios autenticados podem realizar essa ação");

        User usuario = this.findById(id);
        User usuario_logado = this.findById(usuarioId);

        if (usuario_logado.getRole() == Role.USER && !usuario_logado.getId().equals(usuario.getId())) {
            throw new UnauthorizedException("Acesso negado: Apenas administradores podem editar usuários");
        }
        if(usuario_logado.getRole() == Role.ADMIN){
            usuario.setRole(dto.getRole());
        }

        if(dto.getName() != null)
            usuario.setName(dto.getName());
        if(dto.getEmail() != null)
            usuario.setEmail(dto.getEmail());
        if(dto.getCpf() != null)
            usuario.setCpf(dto.getCpf());
        if(dto.getBirthday() != null)
            usuario.setBirthday(dto.getBirthday());
        if(dto.getCell_phone() != null)
            usuario.setCellPhone(dto.getCell_phone());
        if(dto.getHome_phone() != null)
            usuario.setHomePhone(dto.getHome_phone());
        if(dto.getWhatsapp() != null)
            usuario.setWhatsapp(dto.getWhatsapp());
        if(dto.getPassword_hash() != null)
            usuario.setPasswordHash(passwordEncoder.encode(dto.getPassword_hash()));

        if (dto.getAddress() != null) {
            AddressCreateDto addrDto = dto.getAddress();
            Address address;

            if (usuario.getAddress() != null) {
                address = usuario.getAddress();
            } else {
                address = new Address();
            }

            if(addrDto.getCityId() != null) {
                City city = cityRepository.findById(addrDto.getCityId())
                        .orElseThrow(() -> new NotFoundException("Cidade não encontrada"));
                address.setCity(city);
            }

            if(addrDto.getPostalCode() != null)
                address.setPostalCode(addrDto.getPostalCode());
            if(addrDto.getStreet() != null)
                address.setStreet(addrDto.getStreet());
            if(addrDto.getNumber() != null)
                address.setNumber(addrDto.getNumber());
            if(addrDto.getNeighborhood() != null)
                address.setNeighborhood(addrDto.getNeighborhood());
            if(addrDto.getComplement() != null)
                address.setComplement(addrDto.getComplement());
            if(addrDto.getReference() != null)
                address.setReference(addrDto.getReference());

            addressRepository.save(address);
            usuario.setAddress(address);
        }

        if(dto.getPhoto() != null) {
            usuario.setPhoto(dto.getPhoto());
        } else if (dto.getPhoto().isEmpty()) {
            usuario.setPhoto(null);
        }

        this.repository.save(usuario);
        usuario.setPasswordHash(null);
        return usuario;
    }

    public void delete(Integer deleteId, User usuarioLogado){
        if(usuarioLogado.getRole() != Role.ADMIN)
            throw new UnauthorizedException("Acesso negado: apenas administradores podem deletar usuários");

        User usuario = this.findById(deleteId);
        this.repository.delete(usuario);
    }

    public Boolean compararSenha(String senha, User usuario){
        return this.passwordEncoder.matches(senha, usuario.getPasswordHash());
    }
}
