/*
======================================================================================
Autor:          Kauê Gomes
Data:           06/09/2025
Projeto:        Quero Doar – Correção do tipo de leveling_feedback_achievement.date.
Versão:         4.0
Descrição:
    Correção do tipo da coluna date na tabela leveling_feedback_achievement de date
    para timestamp with time zone.

Objetivo:
    Garantir que a coluna date armazene informações de data e hora com fuso horário,
    melhorando a precisão dos registros de conquistas de feedback.
======================================================================================
*/
BEGIN;
    --dependencies drop
    DROP VIEW public.v_user;
    DROP VIEW public.v_user_feedback_achievement;

    --fix column type
    ALTER TABLE IF EXISTS public.leveling_feedback_achievement DROP COLUMN IF EXISTS date;
    ALTER TABLE IF EXISTS public.leveling_feedback_achievement
        ADD COLUMN date timestamp with time zone NOT NULL;

    --recreate dependencies
    CREATE OR REPLACE VIEW public.v_user_feedback_achievement
    AS
    SELECT lfa.user_id,
           fa.feedback_achievement_id,
           lfa.date,
           fa.amount,
           fa.description
    FROM leveling_feedback_achievement lfa
             JOIN feedback_achievement fa USING (feedback_achievement_id);

    ALTER TABLE public.v_user_feedback_achievement
        OWNER TO quero_doar;

    CREATE OR REPLACE VIEW public.v_user
    AS
    SELECT u.user_id,
           u.name,
           u.email,
           u.cell_phone,
           u.home_phone,
           u.whatsapp,
           u.is_active,
           u.verified,
           u.role,
           u.photo,
           CASE
               WHEN count(vus.*) = 0 THEN NULL::json
               ELSE to_json(vus.*)
               END AS v_user_statistic,
           CASE
               WHEN count(va.*) = 0 THEN NULL::json
               ELSE to_json(va.*)
               END AS v_address,
           CASE
               WHEN count(vuda.*) = 0 THEN NULL::json
               ELSE json_agg(to_json(vuda.*))
               END AS v_user_donation_achievement,
           CASE
               WHEN count(vufa.*) = 0 THEN NULL::json
               ELSE json_agg(to_json(vufa.*))
               END AS v_user_feedback_achievement
    FROM "user" u
             LEFT JOIN v_user_statistic vus USING (user_id)
             LEFT JOIN v_address va USING (address_id)
             LEFT JOIN v_user_donation_achievement vuda ON u.user_id = vuda.user_id
             LEFT JOIN v_user_feedback_achievement vufa ON u.user_id = vufa.user_id
    GROUP BY u.user_id, u.name, u.email, u.cell_phone, u.home_phone, u.whatsapp, u.is_active, u.verified, u.role, va.*, vus.*;

    ALTER TABLE public.v_user
        OWNER TO quero_doar;
END;
