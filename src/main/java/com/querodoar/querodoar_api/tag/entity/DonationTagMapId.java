package com.querodoar.querodoar_api.tag.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.Hibernate;

import java.io.Serializable;
import java.util.Objects;

@Getter
@Setter
@Embeddable
public class DonationTagMapId implements Serializable {
    private static final long serialVersionUID = 6287387516993731755L;
    @NotNull
    @Column(name = "donation_id", nullable = false)
    private Integer donationId;

    @NotNull
    @Column(name = "donation_tag_id", nullable = false)
    private Integer donationTagId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        DonationTagMapId entity = (DonationTagMapId) o;
        return Objects.equals(this.donationTagId, entity.donationTagId) &&
                Objects.equals(this.donationId, entity.donationId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(donationTagId, donationId);
    }

}