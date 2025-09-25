/*
==================================================================================
Autor:          Kauê Gomes
Data:           24/09/2025
Projeto:        Quero Doar – Adiciona a informação de nível à view do hall da fama
Versão:         11.0
Descrição:
    Este roteiro adiciona a coluna v_user_experience_last_month.level e adiciona
    índice composto entre as colunas donation.creator_user_id e donation.status
    para melhorar a performance da consulta da view.
==================================================================================
*/

BEGIN;
    CREATE OR REPLACE VIEW public.v_user_experience_last_month
    AS
    SELECT u.user_id,
           u.name,
           u.photo,
           ((city.name::text || ' ('::text) || s.acronym::text) || ')'::text AS location,
           count(d.donation_id) AS donation_month,
           COALESCE(sum(ll.exp_points), 0::bigint) AS exp_month,
           level.level
    FROM "user" u
             INNER JOIN leveling ON u.user_id = leveling.user_id
             INNER JOIN level ON leveling.level_id = level.level
             LEFT JOIN leveling_log ll ON u.user_id = ll.user_id AND ll.date >= (date_trunc('month'::text, now()) - '1 mon'::interval) AND ll.date < date_trunc('month'::text, now())
             LEFT JOIN donation d ON u.user_id = d.creator_user_id AND d.status = 'F'::"char"
             LEFT JOIN address a ON u.address_id = a.address_id
             LEFT JOIN city ON a.city_id = city.city_id
             LEFT JOIN state s ON city.state_id = s.state_id
    GROUP BY u.user_id, city.name, s.acronym, level.level
    ORDER BY (COALESCE(sum(ll.exp_points), 0::bigint)) DESC, (count(d.donation_id)) DESC, u.name;

    CREATE INDEX idx_creator_user_status ON public.donation (creator_user_id, status);
END;