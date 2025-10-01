package com.querodoar.querodoar_api.tag.repository;

import com.querodoar.querodoar_api.tag.entity.DonationTag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TagRepository extends JpaRepository<DonationTag,Integer> {
}
