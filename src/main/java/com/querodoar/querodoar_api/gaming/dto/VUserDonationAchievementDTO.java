package com.querodoar.querodoar_api.gaming.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.querodoar.querodoar_api.gaming.view.VUserDonationAchievement;
import lombok.Data;
import java.time.OffsetDateTime;
import lombok.experimental.FieldNameConstants;

@FieldNameConstants
@Data
public class VUserDonationAchievementDTO {
    @JsonProperty(Fields.userId)
    @JsonAlias("user_id")
    private Integer userId;
    @JsonProperty(Fields.donationAchievementId)
    @JsonAlias("donation_achievement_id")
    private Integer donationAchievementId;
    @JsonProperty(Fields.date)
    @JsonAlias("date")
    private OffsetDateTime date;
    @JsonProperty(Fields.amount)
    @JsonAlias("amount")
    private Integer amount;
    @JsonProperty(Fields.donationType)
    @JsonAlias("donation_type")
    private Character donationType;
    @JsonProperty(Fields.donationTypeIndicator)
    @JsonAlias("donation_type_indicator")
    private String donationTypeIndicator;
    @JsonProperty(Fields.description)
    @JsonAlias("description")
    private String description;

    public VUserDonationAchievementDTO(VUserDonationAchievement entity) {
        this.userId = entity.getId().getUserId();
        this.donationAchievementId = entity.getId().getDonationAchievementId();
        this.date = entity.getDate();
        this.amount = entity.getAmount();
        this.donationType = entity.getDonationType();
        this.donationTypeIndicator = entity.getDonationTypeIndicator();
        this.description = entity.getDescription();
    }

    public VUserDonationAchievementDTO() {
    }

    public static VUserDonationAchievementDTO fromEntity(VUserDonationAchievement entity) {
        return new VUserDonationAchievementDTO(entity);
    }
}