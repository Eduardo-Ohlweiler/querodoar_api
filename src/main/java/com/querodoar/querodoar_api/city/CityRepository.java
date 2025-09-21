package com.querodoar.querodoar_api.city;

import com.querodoar.querodoar_api.city.entity.City;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CityRepository extends JpaRepository<City, Integer> {
}
