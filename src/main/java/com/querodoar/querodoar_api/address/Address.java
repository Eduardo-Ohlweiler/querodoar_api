package com.querodoar.querodoar_api.address;

import com.querodoar.querodoar_api.usuario.User;
import jakarta.persistence.*;

@Entity
public class Address {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "address_id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "user_id", foreignKey = @ForeignKey(value = ConstraintMode.CONSTRAINT, name = "user_fk"))
    private User user;
}
