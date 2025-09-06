package com.querodoar.querodoar_api.usuario;

import com.querodoar.querodoar_api.usuario.view.VUser;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface VUserRepository extends JpaRepository<VUser, Integer> {
    Optional<VUser> findByEmail(String email);
    Optional<VUser> findByUserId(Integer userId);
}
