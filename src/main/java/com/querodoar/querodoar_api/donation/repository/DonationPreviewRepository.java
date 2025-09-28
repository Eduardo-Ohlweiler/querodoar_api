package com.querodoar.querodoar_api.donation.repository;

import com.querodoar.querodoar_api.donation.dto.DonationPreviewDTO;
import com.querodoar.querodoar_api.usuario.dtos.UserMinimalDTO;
import jakarta.annotation.Nullable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.List;

@Repository
public class DonationPreviewRepository {
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private ObjectMapper objectMapper;

    public List<DonationPreviewDTO> findDonationPreviewWhereStatusDOrderByDistanceKmAscDateDesc(@Nullable String cityName, Integer limit) {
        String sql =
                "WITH distance AS (" +
                "   SELECT d.city_id, d.distance_km" +
                "   FROM f_city_distance_km((SELECT location_cube FROM city WHERE name = ?)) d" +
                ") " +
                "SELECT v.donation_id, v.title, v.description, v.photo, v.is_donation, v.is_public, v.location, v.date, v.user_minimal, v.status, d.distance_km " +
                "FROM v_donation_preview v " +
                "INNER JOIN distance d USING(city_id) " +
                "WHERE v.status = 'D' " +
                "ORDER BY d.distance_km, v.date DESC LIMIT ?;";

        return jdbcTemplate.query(sql, (rs, rowNum) -> mapResultSetToDonationPreviewDTO(rs), cityName, limit);
    }

    private DonationPreviewDTO mapResultSetToDonationPreviewDTO(ResultSet rs) throws SQLException {
        DonationPreviewDTO dto = new DonationPreviewDTO();
        dto.setDonationId(rs.getInt("donation_id"));
        dto.setTitle(rs.getString("title"));
        dto.setDescription(rs.getString("description"));
        dto.setPhoto(rs.getString("photo"));
        dto.setIsDonation(rs.getBoolean("is_donation"));
        dto.setIsPublic(rs.getBoolean("is_public"));
        dto.setLocation(rs.getString("location"));
        dto.setDate(rs.getObject("date", OffsetDateTime.class));

        Double distanceKm = rs.getObject("distance_km", Double.class);
        dto.setDistanceKm(distanceKm);

        dto.setStatus(rs.getString("status").charAt(0));

        String userJson = rs.getString("user_minimal");
        try {
            if (userJson != null) {
                UserMinimalDTO userMinimal = objectMapper.readValue(userJson, UserMinimalDTO.class);
                dto.setUserMinimal(userMinimal);
            }
        } catch (IOException e) {
            throw new RuntimeException("Falha ao desserializar o JSON do usuário: " + userJson, e);
        }

        return dto;
    }
}
