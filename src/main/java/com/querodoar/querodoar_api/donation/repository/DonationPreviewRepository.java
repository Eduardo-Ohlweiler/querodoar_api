package com.querodoar.querodoar_api.donation.repository;

import com.querodoar.querodoar_api.donation.dto.DonationPreviewDTO;
import com.querodoar.querodoar_api.usuario.dtos.UserMinimalDTO;
import com.querodoar.querodoar_api.utils.PagedResult;
import jakarta.annotation.Nullable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

@Repository
public class DonationPreviewRepository {
    @Autowired
    private NamedParameterJdbcTemplate namedParameterJdbcTemplate;

    @Autowired
    private ObjectMapper objectMapper;

    public List<DonationPreviewDTO> findDonationPreviewWhereStatusDOrderByDistanceKmAscDateDesc(@Nullable String cityName, Integer limit) {
        String sql =
                "WITH distance AS (" +
                "   SELECT d.city_id, d.distance_km" +
                "   FROM f_city_distance_km((SELECT location_cube FROM city WHERE name = :cityName)) d" +
                ") " +
                "SELECT v.donation_id, v.title, v.description, v.photo, v.is_donation, v.is_public, v.location, v.date, v.user_minimal, v.status, d.distance_km " +
                "FROM v_donation_preview v " +
                "INNER JOIN distance d USING(city_id) " +
                "WHERE v.status = 'D' " +
                "ORDER BY d.distance_km, v.date DESC LIMIT :limit;";

        Map<String, Object> params = new HashMap<>();
        params.put("cityName", cityName);
        params.put("limit", limit);

        return namedParameterJdbcTemplate.query(sql, params, (rs, rowNum) -> mapResultSetToDonationPreviewDTO(rs));
    }

    public PagedResult<DonationPreviewDTO> searchDonationPreview(
            String cityName,
            @Nullable String searchTerm,
            Integer page,
            Integer size,
            Boolean sortByDistance,
            Boolean isPublic1,
            Boolean isPublic2,
            @Nullable Integer distanceKm,
            @Nullable List<Integer> statesIds,
            @Nullable List<Integer> citiesIds,
            @Nullable List<Integer> subcategoriesIds,
            @Nullable List<Integer> tagsIds
            ) {
        // Executa a consulta principal e mapeia os resultados
        String sql = """
                with distance as (
                	 select d.city_id, d.distance_km
                	 from f_city_distance_km((select location_cube from city where name = :cityName)) d
                )
                select
                    (count(*) over()) as total_count,
                	v.donation_id, v.title, v.description, v.photo, v.is_donation, v.is_public,
                	v.location, v.date, v.user_minimal, v.status, d.distance_km
                from v_donation_preview v
                """ + (searchTerm != null ? "    cross join (select plainto_tsquery('portuguese', :searchTherm) AS query) q " : "") + """
                	inner join distance d on v.city_id = d.city_id
                    inner join city c on v.city_id = c.city_id
                where
                	v.status = 'D'
                	and (v.is_public = :isPublic1 or v.is_public = :isPublic2)
                """ + (searchTerm != null ? "    and v.document_tsv @@ q.query " : "") + """
                """ + (citiesIds != null && !citiesIds.isEmpty() ? "   and v.city_id in (:citiesIds) " : "") + """
                """ + (statesIds != null && !statesIds.isEmpty() ? "   and c.state_id in (:stateIds) " : "") + """
                """ + (subcategoriesIds != null && !subcategoriesIds.isEmpty() ? "   and v.subcategory_id in (:subcategoriesIds) " : "") + """
                """ + (tagsIds != null && !tagsIds.isEmpty() ? "   and v.donation_id in (select distinct donation_id from donation_tag_map where donation_tag_id in (:tagsIds)) " : "") + """
                """ + (distanceKm != null ? "   and d.distance_km <= :distanceKm " : "") + """
                order by
                """ + (sortByDistance ? "   d.distance_km, " : " ") + """
                """ + (searchTerm != null ? "   v.date desc, ts_rank(v.document_tsv, q.query) desc " : " v.date desc ") + """
                limit :limit
                offset :offset;
                """;

        Map<String, Object> params = new HashMap<>();
        params.put("cityName", cityName);
        params.put("searchTherm", searchTerm);
        params.put("isPublic1", isPublic1);
        params.put("isPublic2", isPublic2);
        if(distanceKm != null) {
            params.put("distanceKm", distanceKm);
        }
        if(citiesIds != null && !citiesIds.isEmpty()) {
            params.put("citiesIds", citiesIds);
        }
        if(statesIds != null && !statesIds.isEmpty()) {
            params.put("stateIds", statesIds);
        }
        if(subcategoriesIds != null && !subcategoriesIds.isEmpty()) {
            params.put("subcategoriesIds", subcategoriesIds);
        }
        if(tagsIds != null && !tagsIds.isEmpty()) {
            params.put("tagsIds", tagsIds);
        }
        params.put("limit", size);
        params.put("offset", page * size);

        AtomicInteger countAtomic = new AtomicInteger(0);

        List<DonationPreviewDTO> resultList = namedParameterJdbcTemplate.query(sql, params, (rs, rowNum) -> {
            if(rowNum == 0) {
                countAtomic.set(rs.getInt("total_count"));
            }
            return mapResultSetToDonationPreviewDTO(rs);
        });

        PagedResult<DonationPreviewDTO> pagedDonationPreviewDTO = new PagedResult<DonationPreviewDTO>();
        pagedDonationPreviewDTO.setElements(resultList);
        pagedDonationPreviewDTO.setTotalElements(countAtomic.get());
        pagedDonationPreviewDTO.setCurrentPage(page);
        pagedDonationPreviewDTO.setPageSize(size);

        return pagedDonationPreviewDTO;
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
