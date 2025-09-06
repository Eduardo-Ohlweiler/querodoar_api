package com.querodoar.querodoar_api.usuario.dtos;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.querodoar.querodoar_api.usuario.view.VUserStatistic;
import lombok.Data;
import lombok.experimental.FieldDefaults;
import lombok.experimental.FieldNameConstants;

import java.math.BigDecimal;

@FieldNameConstants
@Data
public class VUserStatisticDTO {
    @JsonProperty(Fields.userId)
    @JsonAlias("user_id")
    private Integer userId;

    @JsonProperty(Fields.feedbackCount)
    @JsonAlias("feedback_count")
    private Long feedbackCount;

    @JsonProperty(Fields.feedbackWithCommentCount)
    @JsonAlias("feedback_with_comment_count")
    private Long feedbackWithCommentCount;

    @JsonProperty(Fields.totalDonationCount)
    @JsonAlias("total_donation_count")
    private Long totalDonationCount;

    @JsonProperty(Fields.sendDonationCount)
    @JsonAlias("send_donation_count")
    private Long sendDonationCount;

    @JsonProperty(Fields.receiveDonationCount)
    @JsonAlias("receive_donation_count")
    private Long receiveDonationCount;

    @JsonProperty(Fields.currentLevel)
    @JsonAlias("current_level")
    private BigDecimal currentLevel;

    @JsonProperty(Fields.currentExp)
    @JsonAlias("current_exp")
    private Integer currentExp;

    @JsonProperty(Fields.nextLevel)
    @JsonAlias("next_level")
    private BigDecimal nextLevel;

    @JsonProperty(Fields.expPointsToNextLevel)
    @JsonAlias("exp_points_to_next_level")
    private Integer expPointsToNextLevel;

    public VUserStatisticDTO(VUserStatistic vUserStatistic) {
        this.userId = vUserStatistic.getUserId();
        this.feedbackCount = vUserStatistic.getFeedbackCount();
        this.feedbackWithCommentCount = vUserStatistic.getFeedbackWithCommentCount();
        this.totalDonationCount = vUserStatistic.getTotalDonationCount();
        this.sendDonationCount = vUserStatistic.getSendDonationCount();
        this.receiveDonationCount = vUserStatistic.getReceiveDonationCount();
        this.currentLevel = vUserStatistic.getCurrentLevel();
        this.currentExp = vUserStatistic.getCurrentExp();
        this.nextLevel = vUserStatistic.getNextLevel();
        this.expPointsToNextLevel = vUserStatistic.getExpPointsToNextLevel();
    }

    public VUserStatisticDTO() {}

    public static VUserStatisticDTO fromEntity(VUserStatistic vUserStatistic) {
        return new VUserStatisticDTO(vUserStatistic);
    }
}
