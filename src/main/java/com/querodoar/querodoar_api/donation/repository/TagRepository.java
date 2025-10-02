package com.querodoar.querodoar_api.donation.repository;

import com.querodoar.querodoar_api.donation.entity.DonationTag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TagRepository extends JpaRepository<DonationTag,Integer> {
}
