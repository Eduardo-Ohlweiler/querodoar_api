package com.querodoar.querodoar_api.donation.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import org.hibernate.Hibernate;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class InterestedId implements Serializable {
    private static final long serialVersionUID = -2802265468685340729L;
    @NotNull
    @Column(name = "donation_id", nullable = false)
    private Integer donationId;

    @NotNull
    @Column(name = "user_id", nullable = false)
    private Integer userId;

    public Integer getDonationId() {
        return donationId;
    }

    public void setDonationId(Integer donationId) {
        this.donationId = donationId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        InterestedId entity = (InterestedId) o;
        return Objects.equals(this.donationId, entity.donationId) &&
                Objects.equals(this.userId, entity.userId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(donationId, userId);
    }

}