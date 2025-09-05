package com.querodoar.querodoar_api.usuario.entity;

import com.querodoar.querodoar_api.usuario.User;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.time.OffsetDateTime;

@Entity
@Table(name = "user_blocking")
public class UserBlocking {
    @Id
    @Column(name = "user_id", nullable = false)
    private Integer id;

    @MapsId
    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @NotNull
    @Column(name = "date", nullable = false)
    private OffsetDateTime date;

    @Column(name = "until")
    private OffsetDateTime until;

    @Size(max = 1000)
    @NotNull
    @Column(name = "reason", nullable = false, length = 1000)
    private String reason;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public OffsetDateTime getDate() {
        return date;
    }

    public void setDate(OffsetDateTime date) {
        this.date = date;
    }

    public OffsetDateTime getUntil() {
        return until;
    }

    public void setUntil(OffsetDateTime until) {
        this.until = until;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

}