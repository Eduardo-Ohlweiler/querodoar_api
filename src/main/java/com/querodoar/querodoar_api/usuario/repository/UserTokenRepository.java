package com.querodoar.querodoar_api.usuario.repository;

import com.querodoar.querodoar_api.usuario.entity.UserToken;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserTokenRepository extends JpaRepository<UserToken, Integer> {
    Optional<UserToken> findByToken(String token);

    /**
     * Encontra o token mais recente (com base na data de criação) para um usuário e tipo,
     * que ainda não foi confirmado.
     * * @param userId O ID do usuário.
     * @param type O tipo de token (ex: 'ACCOUNT_VERIFICATION').
     * @return um Optional contendo o UserToken se encontrado, ou um Optional vazio caso contrário.
     */
    Optional<UserToken> findFirstByUserIdAndTypeAndConfirmedAtIsNullOrderByCreatedAtDesc(Integer userId, String type);

}
