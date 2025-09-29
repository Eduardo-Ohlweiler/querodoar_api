package com.querodoar.querodoar_api.location.repository;

import com.querodoar.querodoar_api.location.dto.StateMinimal;
import com.querodoar.querodoar_api.location.entity.State;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StateRepository extends JpaRepository<State, Integer> {
    @Query(value = "select state_id from state inner join city using (state_id) where city.name = :cityName", nativeQuery = true)
    Integer findStateIdByCityName(@Param("cityName") String cityName);

    @Query("select new com.querodoar.querodoar_api.location.dto.StateMinimal(s.id, s.name, s.acronym) from State s")
    List<StateMinimal> findAllStateMinimal();
}
