package com.querodoar.querodoar_api.utils;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class PagedResult<T> {
    private List<T> elements;
    private long totalElements;
    private int currentPage;
    private int pageSize;
}
