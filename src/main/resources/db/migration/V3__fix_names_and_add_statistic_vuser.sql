/*
======================================================================================
Autor:          Kauê Gomes
Data:           06/09/2025
Projeto:        Quero Doar – Correção de nomes e adição de estatísticas na view v_user
Versão:         3.0
Descrição:
    Este roteiro altera a view v_user para corrigir nomes das colunas que referenciam a
    v_donation_achievement e v_feedback_achievement para corresponder aos nomes corretos
    das views v_user_donation_achievement e v_user_feedback_achievement. Além disso,
    adiciona uma nova coluna com a v_user_statistic para fornecer informações adicionais
    sobre as estatísticas do usuário, para evitar redundância, as colunas v_user.level e
    v_user.experience foram removidas.

Objetivo:
    Garantir um objeto que exponha todos os dados relevantes de um usuário.

Observações:
    - Compatível com PostgreSQL.
    - Inclui remove e cria novamente a v_user com estruturação diferente.
======================================================================================
*/

BEGIN;
    DROP VIEW public.v_user;

    CREATE OR REPLACE VIEW public.v_user AS
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
    GROUP BY u.user_id, u.name, u.email, u.cell_phone, u.home_phone,
             u.whatsapp, u.is_active, u.verified, u.role, va.*, vus.*;

    ALTER TABLE public.v_user
        OWNER TO quero_doar;
END;
