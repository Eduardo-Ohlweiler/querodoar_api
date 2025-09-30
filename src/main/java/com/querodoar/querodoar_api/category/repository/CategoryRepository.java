package com.querodoar.querodoar_api.category.repository;

import com.querodoar.querodoar_api.category.dto.CategoryDTO;
import com.querodoar.querodoar_api.category.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryRepository  extends JpaRepository<Category,Integer> {
    @Query("select c from from Category c join fetch c.subcategories order by c.name" )
    List<Category> findAllCategoriesWithSubcategories();
}
