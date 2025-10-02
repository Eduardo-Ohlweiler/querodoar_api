package com.querodoar.querodoar_api.donation.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Getter
@Setter
@Entity
@Table(name = "donation_tag_map")
public class DonationTagMap {
    @EmbeddedId
    private DonationTagMapId id;

    @MapsId("donationId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "donation_id", nullable = false)
    private Donation donation;

    @MapsId("donationTagId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "donation_tag_id", nullable = false)
    private DonationTag donationTag;

}