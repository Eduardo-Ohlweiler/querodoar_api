package com.querodoar.querodoar_api.usuario.repository;

import com.querodoar.querodoar_api.usuario.view.VUserExperienceLastMonth;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VUserExperienceLastMonthService extends JpaRepository<VUserExperienceLastMonth,Integer> {
    @Query(value = "SELECT * FROM v_user_experience_last_month LIMIT :limit", nativeQuery = true)
    List<VUserExperienceLastMonth> findWithLimit(@Param("limit") int limit);
}
