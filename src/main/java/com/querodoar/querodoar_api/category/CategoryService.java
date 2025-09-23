package com.querodoar.querodoar_api.category;

import com.querodoar.querodoar_api.category.repository.VCategoryDonationAvailableRepository;
import com.querodoar.querodoar_api.category.view.VCategoryDonationAvailable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryService {

    @Autowired
    private VCategoryDonationAvailableRepository vCategoryDonationAvailableRepository;

    public List<VCategoryDonationAvailable> getVCategoryDonationAvailable(){
        return this.vCategoryDonationAvailableRepository.findAll();
    }
}
