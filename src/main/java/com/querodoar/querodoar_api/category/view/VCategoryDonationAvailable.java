package com.querodoar.querodoar_api.category.view;

import com.querodoar.querodoar_api.category.entity.Category;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Immutable;

/**
 * Mapping for DB view
 */
@Getter
@Setter
@Entity
@Immutable
@Table(name = "v_category_donation_available")
public class VCategoryDonationAvailable {
    @Id
    @Column(name = "category_id")
    private Integer categoryId;

    @Column(name = "name")
    private String name;

    @Column(name = "donation_available")
    private Long donationAvailable;

}