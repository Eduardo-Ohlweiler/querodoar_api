package com.querodoar.querodoar_api.gaming.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import org.hibernate.Hibernate;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class LevelingFeedbackAchievementId implements Serializable {
    private static final long serialVersionUID = -1554248747243717760L;
    @NotNull
    @Column(name = "user_id", nullable = false)
    private Integer userId;

    @NotNull
    @Column(name = "feedback_achievement_id", nullable = false)
    private Integer feedbackAchievementId;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getFeedbackAchievementId() {
        return feedbackAchievementId;
    }

    public void setFeedbackAchievementId(Integer feedbackAchievementId) {
        this.feedbackAchievementId = feedbackAchievementId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        LevelingFeedbackAchievementId entity = (LevelingFeedbackAchievementId) o;
        return Objects.equals(this.feedbackAchievementId, entity.feedbackAchievementId) &&
                Objects.equals(this.userId, entity.userId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(feedbackAchievementId, userId);
    }

}