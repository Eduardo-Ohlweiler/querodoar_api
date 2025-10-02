package com.querodoar.querodoar_api.donation.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.querodoar.querodoar_api.donation.entity.DonationTag;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DonationTagDTO {
    @JsonProperty("donationTagId")
    @JsonAlias("donation_tag_id")
    private Integer donationTagId;

    @JsonProperty("name")
    @JsonAlias("name")
    private String name;

    public DonationTagDTO(DonationTag donationTag) {
        this.setDonationTagId(donationTag.getId());
        this.setName(donationTag.getName());
    }
}
