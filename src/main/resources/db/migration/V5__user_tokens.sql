/*
======================================================================================
Autor:          Kauê Gomes
Data:           17/09/2025
Projeto:        Quero Doar – Criação da tabela user_tokens.
Versão:         5.0
Descrição:
    Cria a tabela user_tokens para armazenamento de tokens do usuário.
======================================================================================
*/

BEGIN;
    CREATE TABLE public.user_tokens
    (
        -- Chave primária sequencial
        user_token_id SERIAL PRIMARY KEY,

        -- Referência ao usuário
        user_id INTEGER NOT NULL,

        -- Tipo do token para maior clareza
        type "char" NOT NULL CHECK (type IN ('A', 'P')),

        -- Token único para identificar a ação
        token VARCHAR(256) NOT NULL UNIQUE,

        -- Timestamps para controle do ciclo de vida do token.
        created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
        expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
        confirmed_at TIMESTAMP WITH TIME ZONE,

        -- Definição da chave estrangeira
        CONSTRAINT fk_user
            FOREIGN KEY (user_id)
                REFERENCES public."user" (user_id)
                ON DELETE CASCADE
    );

    -- Adiciona um índice na coluna user_id para otimizar buscas por usuário
    CREATE INDEX idx_user_tokens_on_user_id ON public.user_tokens(user_id);

    -- Define o proprietário da tabela
    ALTER TABLE IF EXISTS public.user_tokens
        OWNER to quero_doar;

    COMMENT ON TABLE public.user_tokens
        IS 'Tabela responsável pelo armazenamento de tokens do usuário.
        A (ACCOUNT_VERIFICATION): Verificação de conta;
        P (PASSWORD_RESET): Recuperação de senha.
        ';

    -- Insere dados na tabela Indicador para a coluna type
    INSERT INTO public.indicator (table_column, domain, indicator) VALUES
        ('user_tokens.type', 'A', 'Verificação de conta'),
        ('user_tokens.type', 'P', 'Recuperação de senha');
END;