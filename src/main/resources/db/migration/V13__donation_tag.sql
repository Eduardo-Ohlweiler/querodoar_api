/*
==================================================================================
Autor:          Kauê Gomes
Data:           28/09/2025
Projeto:        Quero Doar – Adiciona o conceito de tags para doações
Versão:         13.0
Descrição:
    Este roteiro cria as tabelas donation_tag e donation_tag_map para permitir a
    categorização de doações por meio de tags. A tabela donation_tag armazena
    as tags disponíveis, enquanto a tabela donation_tag_map faz o mapeamento entre
    doações e suas respectivas tags. Além disso, popula a tabela donation_tag com
    valores fixos e ajusta as permissões para garantir a integridade dos dados.

Objetivo:
    - Permitir a categorização de doações utilizando tags predefinidas.
    - Facilitar a busca e filtragem de doações com base em suas características.
    - Garantir a integridade e segurança dos dados nas tabelas de tags.

Observações:
    - Compatível com PostgreSQL.
    - Inclui criação de tabelas, inserção de dados e ajuste de permissões.
    - A tabela donation_tag é populada com tags fixas representando o estado
      de conservação dos itens doados.
    - Permissões ajustadas: apenas SELECT público em donation_tag, bloqueando
      alterações diretas.
==================================================================================
*/
BEGIN;
    -- Tabela para tags de doações
    CREATE TABLE public.donation_tag
    (
        donation_tag_id serial NOT NULL,
        name character varying(60) NOT NULL,
        PRIMARY KEY (donation_tag_id)
    );

    ALTER TABLE IF EXISTS public.donation_tag
        OWNER to quero_doar;

    -- Popula com valores fixos
    INSERT INTO public.donation_tag (name) VALUES
                                               ('Novo em folha'),('Quase novo'),('Bem conservado'),
                                               ('Com sinais de uso'),('Precisa de reparos');

    -- Bloqueio de alteração em tabela de referência
    REVOKE INSERT, UPDATE, DELETE ON public.donation_tag FROM public;
    GRANT SELECT ON public.donation_tag TO public;

    --Tabela de mapeamento
    CREATE TABLE public.donation_tag_map
    (
        donation_id integer NOT NULL,
        donation_tag_id integer NOT NULL,
        PRIMARY KEY (donation_id, donation_tag_id),
        FOREIGN KEY (donation_id)
            REFERENCES public.donation (donation_id) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE CASCADE
            NOT VALID,
        FOREIGN KEY (donation_tag_id)
            REFERENCES public.donation_tag (donation_tag_id) MATCH SIMPLE
            ON UPDATE CASCADE
            ON DELETE CASCADE
            NOT VALID
    );

    ALTER TABLE IF EXISTS public.donation_tag_map
        OWNER to quero_doar;
END;