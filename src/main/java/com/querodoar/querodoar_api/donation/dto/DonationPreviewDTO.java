package com.querodoar.querodoar_api.donation.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.querodoar.querodoar_api.usuario.dtos.UserMinimalDTO;
import lombok.Data;

import java.time.OffsetDateTime;

@Data
public class DonationPreviewDTO {

    @JsonProperty("donationId")
    @JsonAlias("donation_id")
    private Integer donationId;

    @JsonProperty("title")
    @JsonAlias("title")
    private String title;

    @JsonProperty("description")
    @JsonAlias("description")
    private String description;

    @JsonProperty("photo")
    @JsonAlias("photo")
    private String photo;

    @JsonProperty("isDonation")
    @JsonAlias("is_donation")
    private Boolean isDonation;

    @JsonProperty("isPublic")
    @JsonAlias("is_public")
    private Boolean isPublic;

    @JsonProperty("location")
    @JsonAlias("location")
    private String location;

    @JsonProperty("date")
    @JsonAlias("date")
    private OffsetDateTime date;

    @JsonProperty("userMinimal")
    @JsonAlias("user_minimal")
    private UserMinimalDTO userMinimal;

    @JsonProperty("status")
    @JsonAlias("status")
    private Character status;

    @JsonProperty("distanceKm")
    @JsonAlias("distance_km")
    private Double distanceKm;
}
