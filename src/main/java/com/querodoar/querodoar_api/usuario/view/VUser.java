package com.querodoar.querodoar_api.usuario.view;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.Immutable;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.util.Map;

/**
 * Mapping for DB view
 */
@Entity
@Immutable
@Table(name = "v_user")
public class VUser {
    @Id
    @Column(name = "user_id")
    private Integer userId;

    @Size(max = 150)
    @Column(name = "name", length = 150)
    private String name;

    @Size(max = 150)
    @Column(name = "email", length = 150)
    private String email;

    @Size(max = 11)
    @Column(name = "cell_phone", length = 11)
    private String cellPhone;

    @Size(max = 10)
    @Column(name = "home_phone", length = 10)
    private String homePhone;

    @Size(max = 15)
    @Column(name = "whatsapp", length = 15)
    private String whatsapp;

    @Column(name = "is_active")
    private Boolean isActive;

    @Column(name = "verified")
    private Boolean verified;

    @Column(name = "role", length = Integer.MAX_VALUE)
    private String role;

    @Size(max = 256)
    @Column(name = "photo", length = 256)
    private String photo;

    @Column(name = "experience")
    private Integer experience;

    @Column(name = "level", precision = 4)
    private BigDecimal level;

    @Column(name = "v_address")
    @JdbcTypeCode(SqlTypes.JSON)
    private Map<String, Object> vAddress;

    @Column(name = "v_donation_achievement")
    @JdbcTypeCode(SqlTypes.JSON)
    private Map<String, Object> vDonationAchievement;

    @Column(name = "v_feedback_achievement")
    @JdbcTypeCode(SqlTypes.JSON)
    private Map<String, Object> vFeedbackAchievement;

    public Integer getUserId() {
        return userId;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getCellPhone() {
        return cellPhone;
    }

    public String getHomePhone() {
        return homePhone;
    }

    public String getWhatsapp() {
        return whatsapp;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public Boolean getVerified() {
        return verified;
    }

    public String getRole() {
        return role;
    }

    public String getPhoto() {
        return photo;
    }

    public Integer getExperience() {
        return experience;
    }

    public BigDecimal getLevel() {
        return level;
    }

    public Map<String, Object> getVAddress() {
        return vAddress;
    }

    public Map<String, Object> getVDonationAchievement() {
        return vDonationAchievement;
    }

    public Map<String, Object> getVFeedbackAchievement() {
        return vFeedbackAchievement;
    }

    protected VUser() {
    }
}