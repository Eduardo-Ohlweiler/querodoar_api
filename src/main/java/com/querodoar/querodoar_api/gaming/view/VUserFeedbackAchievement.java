package com.querodoar.querodoar_api.gaming.view;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Size;
import org.hibernate.annotations.Immutable;

import java.time.OffsetDateTime;

/**
 * Mapping for DB view
 */
@Entity
@Immutable
@Table(name = "v_user_feedback_achievement")
public class VUserFeedbackAchievement {
    @EmbeddedId
    private VUserFeedbackAchievementId id;

    @Column(name = "date")
    private OffsetDateTime date;

    @Column(name = "amount")
    private Integer amount;

    @Size(max = 60)
    @Column(name = "description", length = 60)
    private String description;

    public VUserFeedbackAchievementId getId() {
        return id;
    }

    public void setId(VUserFeedbackAchievementId id) {
        this.id = id;
    }

    public OffsetDateTime getDate() {
        return date;
    }

    public Integer getAmount() {
        return amount;
    }

    public String getDescription() {
        return description;
    }

    protected VUserFeedbackAchievement() {
    }
}