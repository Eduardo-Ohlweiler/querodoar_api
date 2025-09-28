package com.querodoar.querodoar_api.city.repository;

import com.querodoar.querodoar_api.city.entity.State;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface StateRepository extends JpaRepository<State, Integer> {
    @Query(value = "select state_id from state inner join city using (state_id) where city.name = :cityName", nativeQuery = true)
    Integer findStateIdByCityName(@Param("cityName") String cityName);
}
