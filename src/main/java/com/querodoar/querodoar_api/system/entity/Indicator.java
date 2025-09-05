package com.querodoar.querodoar_api.system.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "indicator")
public class Indicator {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "indicator_id", nullable = false)
    private Integer id;

    @Size(max = 80)
    @NotNull
    @Column(name = "table_column", nullable = false, length = 80)
    private String tableColumn;

    @NotNull
    @Column(name = "domain", nullable = false)
    private Character domain;

    @Size(max = 60)
    @NotNull
    @Column(name = "indicator", nullable = false, length = 60)
    private String indicator;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTableColumn() {
        return tableColumn;
    }

    public void setTableColumn(String tableColumn) {
        this.tableColumn = tableColumn;
    }

    public Character getDomain() {
        return domain;
    }

    public void setDomain(Character domain) {
        this.domain = domain;
    }

    public String getIndicator() {
        return indicator;
    }

    public void setIndicator(String indicator) {
        this.indicator = indicator;
    }

}