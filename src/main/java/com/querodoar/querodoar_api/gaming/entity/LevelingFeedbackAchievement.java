package com.querodoar.querodoar_api.gaming.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;

import java.time.OffsetTime;

@Entity
@Table(name = "leveling_feedback_achievement")
public class LevelingFeedbackAchievement {
    @EmbeddedId
    private LevelingFeedbackAchievementId id;

    @MapsId("userId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private Leveling user;

    @MapsId("feedbackAchievementId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "feedback_achievement_id", nullable = false)
    private FeedbackAchievement feedbackAchievement;

    @NotNull
    @Column(name = "date", nullable = false)
    private OffsetTime date;

    public LevelingFeedbackAchievementId getId() {
        return id;
    }

    public void setId(LevelingFeedbackAchievementId id) {
        this.id = id;
    }

    public Leveling getUser() {
        return user;
    }

    public void setUser(Leveling user) {
        this.user = user;
    }

    public FeedbackAchievement getFeedbackAchievement() {
        return feedbackAchievement;
    }

    public void setFeedbackAchievement(FeedbackAchievement feedbackAchievement) {
        this.feedbackAchievement = feedbackAchievement;
    }

    public OffsetTime getDate() {
        return date;
    }

    public void setDate(OffsetTime date) {
        this.date = date;
    }

}