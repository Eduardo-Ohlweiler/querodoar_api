package com.querodoar.querodoar_api.donation.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "donation_keyword")
public class DonationKeyword {
    @EmbeddedId
    private DonationKeywordId id;

    @MapsId("donationId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "donation_id", nullable = false)
    private Donation donation;

    public DonationKeywordId getId() {
        return id;
    }

    public void setId(DonationKeywordId id) {
        this.id = id;
    }

    public Donation getDonation() {
        return donation;
    }

    public void setDonation(Donation donation) {
        this.donation = donation;
    }

}