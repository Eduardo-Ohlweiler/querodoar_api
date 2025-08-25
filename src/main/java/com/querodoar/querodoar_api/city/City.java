package com.querodoar.querodoar_api.city;

import jakarta.persistence.*;

@Entity
public class City {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "city_id")
    private Integer id;
}
