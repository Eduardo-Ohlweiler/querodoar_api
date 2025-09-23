/*
======================================================================================
Autor:          Kauê Gomes
Data:           23/09/2025
Projeto:        Quero Doar – view para contagem de doações disponíveis por categoria
                f_donation_preview_final.
Versão:         8.0
Descrição:
    Cria a view v_category_donation_available e índices para otimização de
    performance.
======================================================================================
*/

BEGIN;
    create or replace view v_category_donation_available as
    select category.category_id
         ,count(donation.*) as donation_available
    from category
             inner join subcategory using (category_id)
             left join donation on subcategory.subcategory_id = donation.subcategory_id
        and donation.status = 'D'
    group by category.category_id;

    create index idx_status on donation (status);
    create index idx_status_subcategory on donation (status, subcategory_id);
    create index idx_category on subcategory (category_id);
END;