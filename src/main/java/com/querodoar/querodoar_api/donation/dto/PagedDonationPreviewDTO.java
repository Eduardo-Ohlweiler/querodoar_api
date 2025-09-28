package com.querodoar.querodoar_api.donation.dto;

import com.querodoar.querodoar_api.utils.PagedResult;
import lombok.Data;
import org.jspecify.annotations.Nullable;

import java.util.List;
import java.util.Map;


/**
 * DTO para representar uma página de pré-visualizações de doações com IDs de localizações.
 * Estende a classe PagedResult para incluir informações de paginação.
 */
@Data
public class PagedDonationPreviewDTO extends PagedResult<DonationPreviewDTO> {
    Map<Integer, @Nullable List<Integer>> locationsIds;
}
