package com.querodoar.querodoar_api.category.view;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.Immutable;

/**
 * Mapping for DB view
 */
@Entity
@Immutable
@Table(name = "v_category")
public class VCategory {
    @Id
    @Column(name = "category_id")
    private Integer categoryId;

    @Column(name = "subcategory_id")
    private Integer subcategoryId;

    @Size(max = 60)
    @Column(name = "category", length = 60)
    private String category;

    @Size(max = 60)
    @Column(name = "subcategory", length = 60)
    private String subcategory;

    public Integer getCategoryId() {
        return categoryId;
    }

    public Integer getSubcategoryId() {
        return subcategoryId;
    }

    public String getCategory() {
        return category;
    }

    public String getSubcategory() {
        return subcategory;
    }

    protected VCategory() {
    }
}