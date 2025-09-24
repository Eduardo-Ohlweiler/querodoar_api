/*
==================================================================================
Autor:          Kauê Gomes
Data:           24/09/2025
Projeto:        Quero Doar – Estrutura de logs de progressão e ranking de usuários
Versão:         10.0
Descrição:
    Este roteiro cria a tabela leveling_log para registrar pontos de experiência
    ganhos pelos usuários, cria índices para otimizar consultas, define uma view
    (v_user_experience_last_month) para exibir o ranking de experiência e doações
    do último mês, popula a tabela progression_guide com identificadores padrão
    e ajusta permissões de acesso.

Objetivo:
    - Registrar de forma estruturada os pontos de experiência (XP) ganhos pelos
      usuários em diferentes contextos, vinculados a guias de progressão.
    - Disponibilizar uma visão consolidada (hall da fama) que mostra os usuários
      com maior experiência e doações concluídas no último mês.
    - Garantir consistência e segurança no uso da tabela progression_guide,
      restringindo alterações diretas e permitindo apenas consultas públicas.

Observações:
    - Compatível com PostgreSQL.
    - Inclui criação de tabela, índices, view e inserções iniciais.
    - A tabela leveling_log referencia as tabelas leveling e progression_guide.
    - A view v_user_experience_last_month agrega dados de usuários, doações,
      localização e experiência.
    - progression_guide é populada com identificadores básicos de progressão
      (doação concluída e pedido de doação concluído).
    - Permissões ajustadas: apenas SELECT público em progression_guide.
==================================================================================
*/

BEGIN;
    -- Criação da tabela leveling_log
    CREATE TABLE public.leveling_log
    (
        leveling_log_id serial NOT NULL,
        user_id integer NOT NULL,
        progression_guide_id integer NOT NULL,
        exp_points integer NOT NULL,
        date timestamp with time zone NOT NULL,
        campaign_id integer,
        PRIMARY KEY (leveling_log_id),
        FOREIGN KEY (user_id)
            REFERENCES public.leveling (user_id) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE CASCADE
            NOT VALID,
        FOREIGN KEY (progression_guide_id)
            REFERENCES public.progression_guide (progression_guide_id) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE CASCADE
            NOT VALID
    );

    ALTER TABLE IF EXISTS public.leveling_log
        OWNER to quero_doar;

    -- Criação dos índices da tabela leveling_log
    CREATE INDEX idx_date ON leveling_log (date);
    CREATE INDEX idx_user ON leveling_log (user_id);

    -- Criação da view para o hall da fama
    CREATE OR REPLACE VIEW public.v_user_experience_last_month AS
    SELECT
        u.user_id,
        u.name,
        u.photo,
        (city.name || ' (' || s.acronym || ')') AS location,
        COUNT(d.donation_id) AS donation_month,
        COALESCE(SUM(ll.exp_points), 0) AS exp_month
    FROM
        "user" AS u
            LEFT JOIN
        leveling_log AS ll ON u.user_id = ll.user_id
            AND ll.date >= date_trunc('month', now()) - interval '1 month'
            AND ll.date <  date_trunc('month', now())
            LEFT JOIN
        donation AS d ON u.user_id = d.creator_user_id AND d.status = 'F'
            LEFT JOIN
        address AS a ON u.address_id = a.address_id
            LEFT JOIN
        city ON a.city_id = city.city_id
            LEFT JOIN
        state AS s ON city.state_id = s.state_id
    GROUP BY
        u.user_id, city.name, s.acronym
    ORDER BY
        exp_month DESC,
        donation_month DESC,
        name ASC;

    -- Popula progression_guide
    INSERT INTO public.progression_guide (identifier, description, exp_points) VALUES
       ('DONATION', 'Doação concluída', 50),
       ('DONATION_REQUEST', 'Pedido de doação concluído', 30);

    -- Bloqueia tabela de referencia
    REVOKE INSERT, UPDATE, DELETE ON progression_guide FROM public; --tabela referencia
    GRANT SELECT ON progression_guide TO public;
END;