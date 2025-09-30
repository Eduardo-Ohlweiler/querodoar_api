package com.querodoar.querodoar_api.category.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.querodoar.querodoar_api.category.entity.Category;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CategoryDTO {
    @JsonProperty("categoryId")
    @JsonAlias("category_id")
    private Integer categoryId;

    @JsonProperty("name")
    @JsonAlias("name")
    private String name;

    @JsonProperty("subcategories")
    @JsonAlias("subcategories")
    private List<SubcategoryDTO> subcategories;

    public CategoryDTO(Category category) {
        this.setCategoryId(category.getId());
        this.setName(category.getName());
        this.setSubcategories(category.getSubcategories().stream().map(SubcategoryDTO::new).toList());
    }
}
