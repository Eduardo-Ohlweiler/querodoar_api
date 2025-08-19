package com.querodoar.querodoar_api.utils;

import java.io.IOException;
import java.util.List;

import com.querodoar.querodoar_api.enums.UsuarioRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.UnavailableException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class JwtFilter extends OncePerRequestFilter {

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String header = request.getHeader("Authorization");

        if(SecurityContextHolder.getContext().getAuthentication() == null && header != null && header.startsWith("Bearer ")) {
            String token = header.substring(7);
            try{
                Integer id = jwtUtil.getId(token);
                UsuarioRole role  = jwtUtil.getRole(token);

                List<GrantedAuthority> authorities = List.of(new SimpleGrantedAuthority("ROLE_"+role));

                Authentication auth = new UsernamePasswordAuthenticationToken(id, null, authorities);

                SecurityContextHolder.getContext().setAuthentication(auth);
            }
            catch(Exception e){
                throw new UnavailableException("Token invalido ou expirado");
            }
        }
        filterChain.doFilter(request, response);
    }

}
