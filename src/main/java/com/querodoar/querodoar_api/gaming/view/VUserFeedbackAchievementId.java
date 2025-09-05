package com.querodoar.querodoar_api.gaming.view;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import org.hibernate.Hibernate;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class VUserFeedbackAchievementId implements Serializable {
    private static final long serialVersionUID = -4963344206213676205L;
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "feedback_achievement_id")
    private Integer feedbackAchievementId;

    public Integer getUserId() {
        return userId;
    }

    public Integer getFeedbackAchievementId() {
        return feedbackAchievementId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        VUserFeedbackAchievementId entity = (VUserFeedbackAchievementId) o;
        return Objects.equals(this.feedbackAchievementId, entity.feedbackAchievementId) &&
                Objects.equals(this.userId, entity.userId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(feedbackAchievementId, userId);
    }

}