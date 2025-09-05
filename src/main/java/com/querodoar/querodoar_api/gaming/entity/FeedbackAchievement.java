package com.querodoar.querodoar_api.gaming.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "feedback_achievement")
public class FeedbackAchievement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "feedback_achievement_id", nullable = false)
    private Integer id;

    @NotNull
    @Column(name = "amount", nullable = false)
    private Integer amount;

    @Size(max = 60)
    @NotNull
    @Column(name = "description", nullable = false, length = 60)
    private String description;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}