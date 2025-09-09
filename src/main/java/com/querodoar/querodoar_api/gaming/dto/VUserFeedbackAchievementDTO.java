package com.querodoar.querodoar_api.gaming.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.querodoar.querodoar_api.gaming.view.VUserFeedbackAchievement;
import lombok.Data;

import java.time.OffsetDateTime;

@Data
public class VUserFeedbackAchievementDTO {
    @JsonProperty("userId")
    @JsonAlias("user_id")
    private Integer userId;
    @JsonProperty("feedbackAchievementId")
    @JsonAlias("feedback_achievement_id")
    private Integer feedbackAchievementId;
    @JsonProperty("date")
    @JsonAlias("date")
    private OffsetDateTime date;
    @JsonProperty("amount")
    @JsonAlias("amount")
    private Integer amount;
    @JsonProperty("description")
    @JsonAlias("description")
    private String description;

    public VUserFeedbackAchievementDTO(VUserFeedbackAchievement entity) {
        this.userId = entity.getId().getUserId();
        this.feedbackAchievementId = entity.getId().getFeedbackAchievementId();
        this.date = entity.getDate();
        this.amount = entity.getAmount();
        this.description = entity.getDescription();
    }

    public VUserFeedbackAchievementDTO() {
    }

    public static VUserFeedbackAchievementDTO fromEntity(VUserFeedbackAchievement entity) {
        return new VUserFeedbackAchievementDTO(entity);
    }
}
