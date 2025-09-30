package com.querodoar.querodoar_api.category;

import com.querodoar.querodoar_api.category.dto.CategoryDTO;
import com.querodoar.querodoar_api.category.entity.Category;
import com.querodoar.querodoar_api.category.repository.CategoryRepository;
import com.querodoar.querodoar_api.category.repository.VCategoryDonationAvailableRepository;
import com.querodoar.querodoar_api.category.view.VCategoryDonationAvailable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryService {

    @Autowired
    private VCategoryDonationAvailableRepository vCategoryDonationAvailableRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    public List<VCategoryDonationAvailable> getVCategoryDonationAvailable(){
        return this.vCategoryDonationAvailableRepository.findAll();
    }

    public List<CategoryDTO> getAllCategories() {
        List<Category> categories = categoryRepository.findAllCategoriesWithSubcategories();
        return categories.stream().map(CategoryDTO::new).toList();
    }
}
