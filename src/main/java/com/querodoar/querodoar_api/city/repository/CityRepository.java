package com.querodoar.querodoar_api.city.repository;

import com.querodoar.querodoar_api.city.entity.City;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CityRepository extends JpaRepository<City, Integer> {
    @Query(value = "select city_id from city where state_id = :stateId", nativeQuery = true)
    List<Integer> findAllCityIdsByStateId(@Param("stateId") Integer stateId);
}
