package com.querodoar.querodoar_api.category;

import com.querodoar.querodoar_api.category.dto.CategoryDTO;
import com.querodoar.querodoar_api.category.entity.Category;
import com.querodoar.querodoar_api.category.view.VCategoryDonationAvailable;
import jakarta.annotation.security.PermitAll;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/category")
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @PermitAll
    @GetMapping("/donation/available")
    public ResponseEntity<List<VCategoryDonationAvailable>> getCategoriesWithDonationAvailable() {
        return ResponseEntity.ok(categoryService.getVCategoryDonationAvailable());
    }

    @GetMapping("/public/all")
    public ResponseEntity<List<CategoryDTO>> getAllCategories() {
        return ResponseEntity.ok(categoryService.getAllCategories());
    }

}
