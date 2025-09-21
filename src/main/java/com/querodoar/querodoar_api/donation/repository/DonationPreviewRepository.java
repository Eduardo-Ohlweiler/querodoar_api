package com.querodoar.querodoar_api.donation.repository;

import com.querodoar.querodoar_api.donation.dto.DonationPreviewDTO;
import com.querodoar.querodoar_api.usuario.dtos.UserMinimalDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.time.OffsetDateTime;
import java.util.List;

@Repository
public class DonationPreviewRepository {
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private ObjectMapper objectMapper;

    public List<DonationPreviewDTO> findDonationPreviewWhereStatusDOrderByDistanceKmAscDateDesc(String cityName, Integer limit) {
        String sql = "SELECT * FROM f_donation_preview_final(?) WHERE status = 'D' ORDER BY distance_km ASC, date DESC LIMIT ?;";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            DonationPreviewDTO dto = new DonationPreviewDTO();
            dto.setDonationId(rs.getInt("donation_id"));
            dto.setTitle(rs.getString("title"));
            dto.setDescription(rs.getString("description"));
            dto.setPhoto(rs.getString("photo"));
            dto.setIsDonation(rs.getBoolean("is_donation"));
            dto.setIsPublic(rs.getBoolean("is_public"));
            dto.setLocation(rs.getString("location"));
            dto.setDate(rs.getObject("date", OffsetDateTime.class));
            dto.setDistanceKm(rs.getDouble("distance_km"));
            dto.setStatus(rs.getString("status").charAt(0));
            String userJson = rs.getString("user_minimal");
            try {
                if (userJson != null) {
                    UserMinimalDTO userMinimal = objectMapper.readValue(userJson, UserMinimalDTO.class);
                    dto.setUserMinimal(userMinimal);
                }
            } catch (IOException e) {
                // É uma boa prática logar o erro ou lançar uma exceção customizada
                throw new RuntimeException("Falha ao desserializar o JSON do usuário: " + userJson, e);
            }

            return dto;
        }, cityName, limit);
    }
}
