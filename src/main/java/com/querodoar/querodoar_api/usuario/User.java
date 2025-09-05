package com.querodoar.querodoar_api.usuario;

import com.querodoar.querodoar_api.address.Address;
import com.querodoar.querodoar_api.city.City;
import com.querodoar.querodoar_api.city.entity.State;
import jakarta.persistence.*;
import org.hibernate.Hibernate;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "\"user\"")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Integer id;
//
//    @OneToOne(fetch = FetchType.LAZY)
//    @JoinColumn(
//            name = "address_id",
//            foreignKey = @ForeignKey(name = "user_address_fk")
//    )

    @ManyToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "address_id", nullable = true)
    private Address address;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "cpf")
    private String cpf;

    @Column(name = "birthday")
    private LocalDate birthday;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @Enumerated(EnumType.STRING)
    @Column(nullable=false)
    private Role role = Role.USER;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "verified")
    private Boolean verified = true;

    @Column(name = "cell_phone")
    private String cellPhone;

    @Column(name = "home_phone")
    private String homePhone;

    @Column(name = "whatsapp")
    private String whatsapp;

    @Column(name = "photo", length = 256, unique = true, nullable = true)
    private String photo;

    public Integer getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public LocalDate getBirthday() {
        return birthday;
    }

    public void setBirthday(LocalDate birthday) {
        this.birthday = birthday;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Boolean getActive() {
        return isActive;
    }

    public void setActive(Boolean active) {
        isActive = active;
    }

    public Boolean getVerified() {
        return verified;
    }

    public void setVerified(Boolean verified) {
        this.verified = verified;
    }

    public String getCellPhone() {
        return cellPhone;
    }

    public void setCellPhone(String cellPhone) {
        this.cellPhone = cellPhone;
    }

    public String getHomePhone() {
        return homePhone;
    }

    public void setHomePhone(String homePhone) {
        this.homePhone = homePhone;
    }

    public String getWhatsapp() {
        return whatsapp;
    }

    public void setWhatsapp(String whatsapp) {
        this.whatsapp = whatsapp;
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public String getPhoto() { return photo; }

    public void setPhoto(String photo) { this.photo = photo; }

    public void unproxy() {
        if (this.getAddress() != null) {
            this.setAddress((Address) Hibernate.unproxy(this.getAddress()));
            if (this.getAddress().getCity() != null) {
                this.getAddress().setCity((City) Hibernate.unproxy(this.getAddress().getCity()));
                if (this.getAddress().getCity().getState() != null) {
                    this.getAddress().getCity().setState((State) Hibernate.unproxy(this.getAddress().getCity().getState()));
                }
            }
        }
    }
}
