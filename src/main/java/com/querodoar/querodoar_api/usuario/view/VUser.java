package com.querodoar.querodoar_api.usuario.view;

import com.querodoar.querodoar_api.address.view.VAddress;
import com.querodoar.querodoar_api.gaming.view.VUserDonationAchievement;
import com.querodoar.querodoar_api.gaming.view.VUserFeedbackAchievement;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.Immutable;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

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

    @Column(name = "v_user_statistic")
    @JdbcTypeCode(SqlTypes.JSON)
    private VUserStatistic vUserStatistic;

    @Column(name = "v_address")
    @JdbcTypeCode(SqlTypes.JSON)
    private VAddress vAddress;

    @Column(name = "v_user_donation_achievement")
    @JdbcTypeCode(SqlTypes.JSON)
    private List<VUserDonationAchievement> vUserDonationAchievement;

    @Column(name = "v_user_feedback_achievement")
    @JdbcTypeCode(SqlTypes.JSON)
    private List<VUserFeedbackAchievement> vUserFeedbackAchievement;

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

    public VUserStatistic getVUserStatistic() {
        return vUserStatistic;
    }

    public VAddress getVAddress() {
        return vAddress;
    }

    public List<VUserDonationAchievement> getVUserDonationAchievement() {
        return vUserDonationAchievement;
    }

    public List<VUserFeedbackAchievement> getVUserFeedbackAchievement() {
        return vUserFeedbackAchievement;
    }

    protected VUser() {
    }
}