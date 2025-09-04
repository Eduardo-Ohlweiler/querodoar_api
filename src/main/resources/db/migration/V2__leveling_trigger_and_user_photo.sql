/*
==================================================================================
Autor:          Kauê Gomes
Data:           03/09/2025
Projeto:        Quero Doar – Trigger para registrar na tabela Leveling e alteração
                na tabela User para armazenar foto do usuário
Versão:         2.0
Descrição:
    Este roteiro cria uma procedure e um trigger para inserir registros na tabela
    Leveling sempre que um novo usuário é adicionado à tabela User. Além disso,
    adiciona uma coluna para armazenar a foto do usuário na tabela User.

Objetivo:
    Garantir que quando um usuário for criado, um registro correspondente seja
    automaticamente adicionado à tabela Leveling, iniciando o sistema de níveis
    e experiência. Também permite armazenar a foto do usuário.

Observações:
    - Compatível com PostgreSQL.
    - Inclui criação de procedure e trigger e alteração em tabelas.
    - A coluna photo em User é do tipo VARCHAR(128) para armazenar o nome do
    arquivo foto do usuário.
    - A procedure insere um registro na tabela Leveling com level 1 e experience 0
==================================================================================
*/

BEGIN;
    --##################### FOTO DO USUÁRIO #####################

    -- Adiciona a coluna photo na tabela User para armazenar a foto do usuário
    ALTER TABLE IF EXISTS public."user"
        ADD COLUMN photo character varying(256);
    ALTER TABLE IF EXISTS public."user"
        ADD UNIQUE (photo);

    --Altera a v_user para incluir a nova coluna photo
    DROP VIEW public.v_user;
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
           ling.experience,
           l.level,
           CASE
               WHEN count(va.*) = 0 THEN NULL::json
               ELSE to_json(va.*)
               END AS v_address,
           CASE
               WHEN count(vuda.*) = 0 THEN NULL::json
               ELSE json_agg(to_json(vuda.*))
               END AS v_donation_achievement,
           CASE
               WHEN count(vufa.*) = 0 THEN NULL::json
               ELSE json_agg(to_json(vufa.*))
               END AS v_feedback_achievement
    FROM "user" u
             JOIN leveling ling USING (user_id)
             JOIN level l USING (level_id)
             LEFT JOIN v_address va USING (address_id)
             LEFT JOIN v_user_donation_achievement vuda ON u.user_id = vuda.user_id
             LEFT JOIN v_user_feedback_achievement vufa ON u.user_id = vufa.user_id
    GROUP BY u.user_id, u.name, u.email, u.cell_phone, u.home_phone, u.whatsapp, u.is_active, u.verified, u.role,
             ling.experience, l.level, va.*;

    ALTER TABLE public.v_user
        OWNER TO quero_doar;

    --##################### TRIGGER LEVELING #####################

    -- Cria a função para inserir um registro na tabela Leveling quando um
    -- registro for inserido na tabela User
    CREATE OR REPLACE FUNCTION public.trigger_add_user_to_leveling()
        RETURNS TRIGGER
        LANGUAGE plpgsql
    AS $$
    BEGIN
        -- Verifica se o user_id já existe na tabela leveling
        IF NOT EXISTS (
            SELECT 1 FROM public.leveling WHERE user_id = NEW.user_id
        ) THEN
            -- Insere novo registro na tabela leveling
            INSERT INTO public.leveling (user_id, experience, level_id, is_active)
            VALUES (NEW.user_id, 0, 1, TRUE);
        END IF;

        RETURN NEW;
    END;
    $$;

    -- Cria o trigger que chama a função após a inserção de um novo usuário
    CREATE TRIGGER trg_add_user_to_leveling
        AFTER INSERT ON public."user"
        FOR EACH ROW
        EXECUTE FUNCTION public.trigger_add_user_to_leveling();

    -- Relaciona todos usuários com a tabela Leveling
    DO $$
        DECLARE
            rec_user RECORD;
        BEGIN
            FOR rec_user IN SELECT user_id FROM public."user" LOOP
                    IF NOT EXISTS (
                        SELECT 1 FROM public.leveling WHERE user_id = rec_user.user_id
                    ) THEN
                        INSERT INTO public.leveling (user_id, experience, level_id, is_active)
                        VALUES (rec_user.user_id, 0, 1, TRUE);
                    END IF;
                END LOOP;
        END;
    $$;
END;
