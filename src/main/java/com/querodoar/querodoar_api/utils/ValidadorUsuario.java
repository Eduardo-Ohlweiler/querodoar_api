package com.querodoar.querodoar_api.utils;

import com.querodoar.querodoar_api.exceptions.ForbiddenException;
import com.querodoar.querodoar_api.exceptions.UnauthorizedException;
import com.querodoar.querodoar_api.usuario.Role;
import com.querodoar.querodoar_api.usuario.User;
import com.querodoar.querodoar_api.usuario.UserRepository;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component
public class ValidadorUsuario {
    private final UserRepository usuarioRepository;

    public ValidadorUsuario(UserRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    private User getUsuarioLogado() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getPrincipal() == null) {
            throw new UnauthorizedException("Usuário não autenticado");
        }

        Integer usuarioId = (Integer) auth.getPrincipal();
        return usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new UnauthorizedException("Usuário não encontrado"));
    }

    public void validarAdmin() {
        User usuarioLogado = getUsuarioLogado();
        if (usuarioLogado.getRole() != Role.ADMIN) {
            throw new ForbiddenException("Acesso negado: apenas administradores podem realizar esta operação");
        }
    }
}
