/*
======================================================================================
Autor:          Kauê Gomes
Data:           23/09/2025
Projeto:        Quero Doar – Adiciona coluna name a view v_category_donation_available.
Versão:         9.0
======================================================================================
*/

BEGIN;

    drop view if exists v_category_donation_available;
    create or replace view v_category_donation_available as
    select category.category_id
        ,category.name
        ,count(donation.*) as donation_available
    from category
        inner join subcategory using (category_id)
        left join donation on subcategory.subcategory_id = donation.subcategory_id
            and donation.status = 'D'
    group by category.category_id, category.name;

END;