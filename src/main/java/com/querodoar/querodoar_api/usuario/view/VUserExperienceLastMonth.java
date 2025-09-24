package com.querodoar.querodoar_api.usuario.view;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Immutable;

import java.math.BigDecimal;

/**
 * Mapping for DB view
 */
@Getter
@Setter
@Entity
@Immutable
@Table(name = "v_user_experience_last_month")
public class VUserExperienceLastMonth {
    @Id
    @Column(name = "user_id")
    private Integer userId;

    @Size(max = 150)
    @Column(name = "name", length = 150)
    private String name;

    @Size(max = 256)
    @Column(name = "photo", length = 256)
    private String photo;

    @Column(name = "location", length = Integer.MAX_VALUE)
    private String location;

    @Column(name = "donation_month")
    private Long donationMonth;

    @Column(name = "exp_month")
    private Long expMonth;

    @Column(name = "level", precision = 4)
    private BigDecimal level;

}