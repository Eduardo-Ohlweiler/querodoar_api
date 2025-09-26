/*
==================================================================================
Autor:          Kauê Gomes
Data:           26/09/2025
Projeto:        Quero Doar – Adiciona suporte a Full Text Search (FTS) na tabela
                 Donation
Versão:         12.0
Descrição:
    Este roteiro cria uma coluna do tipo tsvector na tabela Donation para
    suportar buscas em texto completo (Full Text Search - FTS) nos campos título
    e descrição. Também cria um índice GIN para otimizar as consultas FTS. Além
    disso, atualiza a view v_donation_preview para incluir a nova coluna e
    melhora o desempenho das consultas com índices adicionais.

Objetivo:
    Melhorar a funcionalidade de busca na aplicação, permitindo buscas mais
    eficientes e relevantes em doações com base no título e descrição.

Observações:
    - Compatível com PostgreSQL.
    - Inclui criação de coluna gerada, índices e atualização de view.
    - A coluna document_tsv é gerada automaticamente a partir dos campos título
    e descrição, utilizando a configuração de idioma português para a tokenização
    e stemming.
    - Índices adicionais são criados para evitar varreduras completas (seq scan)
    nas consultas planejadas.
    - A função f_donation_preview_final foi removida por questões de performance.
==================================================================================
*/

BEGIN;
    -- Adiciona coluna document_tsv para FTS
    ALTER TABLE donation
        ADD COLUMN document_tsv tsvector GENERATED ALWAYS AS (
            setweight(to_tsvector('portuguese', coalesce(title, '')), 'A') ||
            setweight(to_tsvector('portuguese', coalesce(description, '')), 'B')
            ) STORED;

    -- Índice para consulta performar melhor com TSG
    CREATE INDEX idx_donation_document_tsv
        ON donation
            USING GIN (document_tsv);

    --função descontinuada por questões de performance
    DROP FUNCTION IF EXISTS f_donation_preview_final(text);

    --Adiciona a coluna v_donation_preview.document_tsv
    DROP VIEW IF EXISTS v_donation_preview;
    create or replace view public.v_donation_preview
    as
    select donation.donation_id
         ,city.city_id
         ,donation.title
         ,donation.description
         ,donation.photos[1] as photo
         ,(case when donation.type = 'D' then true else false end) as is_donation
         ,donation.is_public
         ,city.name || ' (' || state.acronym || ')' as location
         ,donation_log.date
         ,json_build_object(
            'user_id', "user".user_id,
            'name', "user".name,
            'photo', "user".photo
          ) as user_minimal
         ,donation.status
         ,donation.document_tsv
    from donation
             inner join address on donation.address_id = address.address_id
             inner join city on address.city_id = city.city_id
             inner join state on city.state_id = state.state_id
             inner join donation_log on donation.donation_id = donation_log.donation_id
        and donation_log.log_type_id = (select log_type_id from log_type where  identifier = 'CREATE')
             inner join "user" on donation.creator_user_id = "user".user_id;

    -- Índuces para evitar seq scan nas consultas planejadas
    CREATE INDEX idx_log_type_donation
        ON donation_log (log_type_id, donation_id);

    CREATE INDEX idx_address_city
        ON address (address_id, city_id);
END;