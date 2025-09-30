package com.querodoar.querodoar_api.category.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.querodoar.querodoar_api.category.entity.Subcategory;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SubcategoryDTO {
    @JsonProperty("subcategoryId")
    @JsonAlias("subcategory_id")
    private Integer subcategoryId;

    @JsonProperty("name")
    @JsonAlias("name")
    private String name;

    public SubcategoryDTO(Subcategory subcategory) {
        this.setSubcategoryId(subcategory.getId());
        this.setName(subcategory.getName());
    }
}
