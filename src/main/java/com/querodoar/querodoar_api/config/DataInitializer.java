package com.querodoar.querodoar_api.config;

import com.querodoar.querodoar_api.usuario.Role;
import com.querodoar.querodoar_api.usuario.User;
import com.querodoar.querodoar_api.usuario.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner initDatabase(UserRepository usuarioRepository, PasswordEncoder passwordEncoder) {
        return args -> {

            // Verifica se já existe algum usuário com role ADMIN
            boolean adminExists = usuarioRepository.existsByRole(Role.ADMIN);

            if (!adminExists) {
                User admin = new User();
                admin.setName("QueroDoar");
                admin.setEmail("admin@querodoar.com");
                admin.setPasswordHash(passwordEncoder.encode("QDAdmin12345@")); // senha criptografada
                admin.setRole(Role.ADMIN);

                usuarioRepository.save(admin);
                System.out.println("Usuário admin criado com sucesso!");
            } else {
                System.out.println("Usuário admin já existe");
            }
        };
    }
}
