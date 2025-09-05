package com.querodoar.querodoar_api.donation.entity;

import com.querodoar.querodoar_api.address.Address;
import com.querodoar.querodoar_api.category.entity.Subcategory;
import com.querodoar.querodoar_api.usuario.User;
import com.vladmihalcea.hibernate.type.array.StringArrayType;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.Type;

import java.math.BigDecimal;
import java.util.Set;

@Entity
@Table(name = "donation")
public class Donation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "donation_id", nullable = false)
    private Integer id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "creator_user_id", nullable = false)
    private User creatorUser;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "target_user_id")
    private User targetUser;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "address_id", nullable = false)
    private Address address;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "subcategory_id", nullable = false)
    private Subcategory subcategory;

    @NotNull
    @Column(name = "type", nullable = false)
    private Character type;

    @NotNull
    @Column(name = "status", nullable = false)
    private Character status;

    @Size(max = 100)
    @NotNull
    @Column(name = "title", nullable = false, length = 100)
    private String title;

    @Size(max = 1000)
    @NotNull
    @Column(name = "description", nullable = false, length = 1000)
    private String description;

    @Type(value = StringArrayType.class)
    @Column(name = "photos", columnDefinition = "varchar [](256)")
    private String[] photos;

    @NotNull
    @Column(name = "is_public", nullable = false)
    private Boolean isPublic = false;

    @Column(name = "creator_rating", precision = 2, scale = 1)
    private BigDecimal creatorRating;

    @Size(max = 1000)
    @Column(name = "creator_feedback", length = 1000)
    private String creatorFeedback;

    @Column(name = "target_rating", precision = 2, scale = 1)
    private BigDecimal targetRating;
    @Size(max = 1000)
    @Column(name = "target_feedback", length = 1000)
    private String targetFeedback;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User getCreatorUser() {
        return creatorUser;
    }

    public void setCreatorUser(User creatorUser) {
        this.creatorUser = creatorUser;
    }

    public User getTargetUser() {
        return targetUser;
    }

    public void setTargetUser(User targetUser) {
        this.targetUser = targetUser;
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public Subcategory getSubcategory() {
        return subcategory;
    }

    public void setSubcategory(Subcategory subcategory) {
        this.subcategory = subcategory;
    }

    public Character getType() {
        return type;
    }

    public void setType(Character type) {
        this.type = type;
    }

    public Character getStatus() {
        return status;
    }

    public void setStatus(Character status) {
        this.status = status;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getIsPublic() {
        return isPublic;
    }

    public String[] getPhotos() { return photos; }

    public void setPhotos(String[] photos) { this.photos = photos; }

    public void setIsPublic(Boolean isPublic) {
        this.isPublic = isPublic;
    }

    public BigDecimal getCreatorRating() {
        return creatorRating;
    }

    public void setCreatorRating(BigDecimal creatorRating) {
        this.creatorRating = creatorRating;
    }

    public String getCreatorFeedback() {
        return creatorFeedback;
    }

    public void setCreatorFeedback(String creatorFeedback) {
        this.creatorFeedback = creatorFeedback;
    }

    public BigDecimal getTargetRating() {
        return targetRating;
    }

    public void setTargetRating(BigDecimal targetRating) {
        this.targetRating = targetRating;
    }

    public String getTargetFeedback() {
        return targetFeedback;
    }

    public void setTargetFeedback(String targetFeedback) {
        this.targetFeedback = targetFeedback;
    }

/*
 TODO [Reverse Engineering] create field to map the 'photos' column
 Available actions: Define target Java type | Uncomment as is | Remove column mapping
    @Column(name = "photos", columnDefinition = "varchar [](256)")
    private Object photos;
*/
}