package com.querodoar.querodoar_api.donation.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import org.hibernate.Hibernate;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class DonationKeywordId implements Serializable {
    private static final long serialVersionUID = -5311601561115981958L;
    @NotNull
    @Column(name = "keyword_id", nullable = false)
    private Integer keywordId;

    @NotNull
    @Column(name = "donation_id", nullable = false)
    private Integer donationId;

    public Integer getKeywordId() {
        return keywordId;
    }

    public void setKeywordId(Integer keywordId) {
        this.keywordId = keywordId;
    }

    public Integer getDonationId() {
        return donationId;
    }

    public void setDonationId(Integer donationId) {
        this.donationId = donationId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        DonationKeywordId entity = (DonationKeywordId) o;
        return Objects.equals(this.keywordId, entity.keywordId) &&
                Objects.equals(this.donationId, entity.donationId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(keywordId, donationId);
    }

}