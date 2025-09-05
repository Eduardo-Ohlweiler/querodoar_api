package com.querodoar.querodoar_api.usuario.view;

import jakarta.persistence.*;
import org.hibernate.annotations.Immutable;

import java.math.BigDecimal;

/**
 * Mapping for DB view
 */
@Entity
@Immutable
@Table(name = "v_user_statistic")
public class VUserStatistic {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "feedback_count")
    private Long feedbackCount;

    @Column(name = "feedback_with_comment_count")
    private Long feedbackWithCommentCount;

    @Column(name = "total_donation_count")
    private Long totalDonationCount;

    @Column(name = "send_donation_count")
    private Long sendDonationCount;

    @Column(name = "receive_donation_count")
    private Long receiveDonationCount;

    @Column(name = "current_level", precision = 4)
    private BigDecimal currentLevel;

    @Column(name = "current_exp")
    private Integer currentExp;

    @Column(name = "next_level", precision = 4)
    private BigDecimal nextLevel;

    @Column(name = "exp_points_to_next_level")
    private Integer expPointsToNextLevel;

    public Integer getUserId() {
        return userId;
    }

    public Long getFeedbackCount() {
        return feedbackCount;
    }

    public Long getFeedbackWithCommentCount() {
        return feedbackWithCommentCount;
    }

    public Long getTotalDonationCount() {
        return totalDonationCount;
    }

    public Long getSendDonationCount() {
        return sendDonationCount;
    }

    public Long getReceiveDonationCount() {
        return receiveDonationCount;
    }

    public BigDecimal getCurrentLevel() {
        return currentLevel;
    }

    public Integer getCurrentExp() {
        return currentExp;
    }

    public BigDecimal getNextLevel() {
        return nextLevel;
    }

    public Integer getExpPointsToNextLevel() {
        return expPointsToNextLevel;
    }

    protected VUserStatistic() {
    }
}