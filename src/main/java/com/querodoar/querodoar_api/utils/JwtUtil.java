package com.querodoar.querodoar_api.utils;

import java.security.Key;
import java.util.Date;

import com.querodoar.querodoar_api.usuario.Role;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

@Component
public class JwtUtil {
    private final String SECRET = "minhaChaveSecretaSuperSegura12345678901234567890";
    private static final long EXPIRA_EM = 86400000;

    private final Key key = Keys.hmacShaKeyFor(SECRET.getBytes());

    public String gerar(Integer id, Role role){
        return Jwts.builder()
                .setSubject(id.toString())
                .claim("role", role)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRA_EM))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    public Integer getId(String token){
        Claims claims = Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token).getBody();
        return Integer.parseInt(claims.getSubject());
    }

    public Role getRole(String token){
        Claims claims = Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token).getBody();
        return Role.valueOf(claims.get("role", String.class));
    }
}
