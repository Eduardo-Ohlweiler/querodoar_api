package com.querodoar.querodoar_api.config;

import com.querodoar.querodoar_api.utils.JwtFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableMethodSecurity
public class SecurityConfig {

    @Autowired
    private JwtFilter jwtFilter;

    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{
        http
                .cors(cors -> cors.disable())
                .csrf(csrf-> csrf.disable())
                .authorizeHttpRequests(auth-> auth
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll() // Permitir OPTIONS
                        //ROTAS PÚBLICAS
                        .requestMatchers("/api/auth/**").permitAll()
                        //LIBERAÇÃO DO SWAGGER
                        .requestMatchers(
                                "/v3/api-docs/**",
                                "/swagger-ui/**",
                                "/swagger-ui.html"
                        ).permitAll()
                        //LIBERAÇÃO PARA ROTAS DE FOTOS DE USUÁRIOS E ANÚNCIOS
                        .requestMatchers("/media/user/**").permitAll()
                        .requestMatchers("/media/donation/**").permitAll()
                        //TODO: Isso aqui não está legal, verificar como liberar (acesso anônimo) com PermitAll na controller
                        .requestMatchers("/api/donation/**").permitAll()
                        .requestMatchers("/api/category/**").permitAll()
                        //TODO: Ideia: deixar um path para cada roda publica (ex: /api/donation/public/**)
                        .requestMatchers("/api/user/public/**").permitAll()
                        .anyRequest().authenticated()
                )
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }
}
