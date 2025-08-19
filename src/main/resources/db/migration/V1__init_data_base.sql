/*
================================================================================
Autor:          Kauê Gomes
Data:           17/08/2025
Projeto:        Quero Doar – Roteiro de Inicialização do Banco de Dados
Descrição:
    Este roteiro cria e popula as tabelas necessárias para a inicialização
    do banco de dados da aplicação Quero Doar, incluindo estruturas,
    chaves primárias e estrangeiras, índices, e dados de referência.

Objetivo:
    Garantir a criação coerente do schema e o carregamento de registros
    essenciais para o funcionamento inicial do sistema.

Observações:
    - Compatível com PostgreSQL.
    - Inclui criação de tabelas de domínio, tabelas transacionais e de
      referência.
    - Estrutura pensada para escalabilidade e manutenibilidade.
	- A tabela progression_guide, que armazena a quantidade de experiência
	  ganha por ação não foi preenchida, pois ainda precisa ser definido o
	  sistema de progressão.
================================================================================
*/

BEGIN;

-- Ordem de drop
DROP PROCEDURE IF EXISTS public.p_update_user_level(integer);
DROP PROCEDURE IF EXISTS public.p_update_donation_achievements(integer);
DROP PROCEDURE IF EXISTS public.p_update_feedback_achievements(integer);
DROP VIEW IF EXISTS public.v_user;
DROP VIEW IF EXISTS public.v_user_donation_achievement;
DROP VIEW IF EXISTS public.v_user_feedback_achievement;
DROP VIEW IF EXISTS public.v_address;
DROP VIEW IF EXISTS public.v_category;
DROP VIEW IF EXISTS public.v_user_statistic;
DROP TABLE IF EXISTS public.progression_guide;
DROP TABLE IF EXISTS public.indicator;
DROP TABLE IF EXISTS public.leveling_feedback_achievement;
DROP TABLE IF EXISTS public.feedback_achievement;
DROP TABLE IF EXISTS public.leveling_donation_achievement;
DROP TABLE IF EXISTS public.donation_achievement;
DROP TABLE IF EXISTS public.leveling;
DROP TABLE IF EXISTS public.level;
DROP TABLE IF EXISTS public.interested;
DROP TABLE IF EXISTS public.donation_log;
DROP TABLE IF EXISTS public.donation_report;
DROP TABLE IF EXISTS public.donation_keyword;
DROP TABLE IF EXISTS public.keyword;
DROP TABLE IF EXISTS public.donation;
DROP TABLE IF EXISTS public.subcategory;
DROP TABLE IF EXISTS public.category;
DROP TABLE IF EXISTS public.user_report;
DROP TABLE IF EXISTS public.user_blocking;
DROP TABLE IF EXISTS public.user_log;
DROP TABLE IF EXISTS public.log_type;
DROP TABLE IF EXISTS public."user";
DROP TABLE IF EXISTS public.address;
DROP TABLE IF EXISTS public.city;
DROP TABLE IF EXISTS public.state;

--Tabelas, índices e insert de dados de referencia
CREATE TABLE IF NOT EXISTS public.state
(
    state_id serial,
    name character varying(60) COLLATE pg_catalog."default" NOT NULL,
    acronym character varying(2) COLLATE pg_catalog."default" NOT NULL,
    ibge_code numeric(2,0) NOT NULL,
    CONSTRAINT state_pkey PRIMARY KEY (state_id),
    CONSTRAINT state_acronym_key UNIQUE (acronym)
);

ALTER TABLE IF EXISTS public.state
    OWNER to quero_doar;

COMMENT ON TABLE public.state
    IS 'A tabela state armazena os dados dos estados brasileiros, incluindo o nome completo, a sigla oficial (UF) e código do IBGE.';

INSERT INTO public.state (name, acronym, ibge_code) VALUES
                                                        ('Acre', 'AC', 12),
                                                        ('Alagoas', 'AL', 27),
                                                        ('Amapá', 'AP', 16),
                                                        ('Amazonas', 'AM', 13),
                                                        ('Bahia', 'BA', 29),
                                                        ('Ceará', 'CE', 23),
                                                        ('Distrito Federal', 'DF', 53),
                                                        ('Espírito Santo', 'ES', 32),
                                                        ('Goiás', 'GO', 52),
                                                        ('Maranhão', 'MA', 21),
                                                        ('Mato Grosso', 'MT', 51),
                                                        ('Mato Grosso do Sul', 'MS', 50),
                                                        ('Minas Gerais', 'MG', 31),
                                                        ('Pará', 'PA', 15),
                                                        ('Paraíba', 'PB', 25),
                                                        ('Paraná', 'PR', 41),
                                                        ('Pernambuco', 'PE', 26),
                                                        ('Piauí', 'PI', 22),
                                                        ('Rio de Janeiro', 'RJ', 33),
                                                        ('Rio Grande do Norte', 'RN', 24),
                                                        ('Rio Grande do Sul', 'RS', 43),
                                                        ('Rondônia', 'RO', 11),
                                                        ('Roraima', 'RR', 14),
                                                        ('Santa Catarina', 'SC', 42),
                                                        ('São Paulo', 'SP', 35),
                                                        ('Sergipe', 'SE', 28),
                                                        ('Tocantins', 'TO', 17);

REVOKE INSERT, UPDATE, DELETE ON state FROM public; --tabela referencia
GRANT SELECT ON state TO public;

CREATE TABLE IF NOT EXISTS public.city
(
    city_id serial,
    state_id integer NOT NULL,
    name character varying(60) COLLATE pg_catalog."default" NOT NULL,
    ibge_code numeric(5,0) NOT NULL,
    CONSTRAINT city_pkey PRIMARY KEY (city_id),
    CONSTRAINT city_state_id_fkey FOREIGN KEY (state_id)
        REFERENCES public.state (state_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.city
    OWNER to quero_doar;

COMMENT ON TABLE public.city
    IS 'A tabela city armazena informações de cidades brasileiras, faz relação com a tabela state.';

CREATE INDEX idx_city_name ON public.city (name); --Para buscar por sufixo de nome de cidade
CREATE INDEX idx_city_state_id ON public.city (state_id); --Para busca de cidades por estado

INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Alta Floresta D''Oeste', 00015;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Alto Alegre dos Parecis', 00379;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Alto Paraíso', 00403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Alvorada D''Oeste', 00346;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Ariquemes', 00023;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Buritis', 00452;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Cabixi', 00031;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Cacaulândia', 00601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Cacoal', 00049;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Campo Novo de Rondônia', 00700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Candeias do Jamari', 00809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Castanheiras', 00908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Cerejeiras', 00056;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Chupinguaia', 00924;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Colorado do Oeste', 00064;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Corumbiara', 00072;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Costa Marques', 00080;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Cujubim', 00940;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Espigão D''Oeste', 00098;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Governador Jorge Teixeira', 01005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Guajará-Mirim', 00106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Itapuã do Oeste', 01104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Jaru', 00114;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Ji-Paraná', 00122;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Machadinho D''Oeste', 00130;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Ministro Andreazza', 01203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Mirante da Serra', 01302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Monte Negro', 01401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Nova Brasilândia D''Oeste', 00148;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Nova Mamoré', 00338;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Nova União', 01435;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Novo Horizonte do Oeste', 00502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Ouro Preto do Oeste', 00155;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Parecis', 01450;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Pimenta Bueno', 00189;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Pimenteiras do Oeste', 01468;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Porto Velho', 00205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Presidente Médici', 00254;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Primavera de Rondônia', 01476;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Rio Crespo', 00262;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Rolim de Moura', 00288;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Santa Luzia D''Oeste', 00296;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'São Felipe D''Oeste', 01484;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'São Francisco do Guaporé', 01492;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'São Miguel do Guaporé', 00320;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Seringueiras', 01500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Teixeirópolis', 01559;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Theobroma', 01609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Urupá', 01708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Vale do Anari', 01757;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Vale do Paraíso', 01807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 11), 'Vilhena', 00304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Acrelândia', 00013;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Assis Brasil', 00054;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Brasiléia', 00104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Bujari', 00138;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Capixaba', 00179;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Cruzeiro do Sul', 00203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Epitaciolândia', 00252;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Feijó', 00302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Jordão', 00328;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Mâncio Lima', 00336;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Manoel Urbano', 00344;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Marechal Thaumaturgo', 00351;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Plácido de Castro', 00385;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Porto Acre', 00807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Porto Walter', 00393;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Rio Branco', 00401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Rodrigues Alves', 00427;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Santa Rosa do Purus', 00435;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Sena Madureira', 00500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Senador Guiomard', 00450;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Tarauacá', 00609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 12), 'Xapuri', 00708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Alvarães', 00029;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Amaturá', 00060;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Anamã', 00086;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Anori', 00102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Apuí', 00144;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Atalaia do Norte', 00201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Autazes', 00300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Barcelos', 00409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Barreirinha', 00508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Benjamin Constant', 00607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Beruri', 00631;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Boa Vista do Ramos', 00680;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Boca do Acre', 00706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Borba', 00805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Caapiranga', 00839;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Canutama', 00904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Carauari', 01001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Careiro', 01100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Careiro da Várzea', 01159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Coari', 01209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Codajás', 01308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Eirunepé', 01407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Envira', 01506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Fonte Boa', 01605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Guajará', 01654;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Humaitá', 01704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Ipixuna', 01803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Iranduba', 01852;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Itacoatiara', 01902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Itamarati', 01951;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Itapiranga', 02009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Japurá', 02108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Juruá', 02207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Jutaí', 02306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Lábrea', 02405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Manacapuru', 02504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Manaquiri', 02553;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Manaus', 02603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Manicoré', 02702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Maraã', 02801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Maués', 02900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Nhamundá', 03007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Nova Olinda do Norte', 03106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Novo Airão', 03205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Novo Aripuanã', 03304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Parintins', 03403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Pauini', 03502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Presidente Figueiredo', 03536;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Rio Preto da Eva', 03569;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Santa Isabel do Rio Negro', 03601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Santo Antônio do Içá', 03700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'São Gabriel da Cachoeira', 03809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'São Paulo de Olivença', 03908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'São Sebastião do Uatumã', 03957;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Silves', 04005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Tabatinga', 04062;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Tapauá', 04104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Tefé', 04203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Tonantins', 04237;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Uarini', 04260;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Urucará', 04302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 13), 'Urucurituba', 04401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'Alto Alegre', 00050;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'Amajari', 00027;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'Boa Vista', 00100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'Bonfim', 00159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'Cantá', 00175;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'Caracaraí', 00209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'Caroebe', 00233;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'Iracema', 00282;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'Mucajaí', 00308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'Normandia', 00407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'Pacaraima', 00456;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'Rorainópolis', 00472;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'São João da Baliza', 00506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'São Luiz', 00605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 14), 'Uiramutã', 00704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Abaetetuba', 00107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Abel Figueiredo', 00131;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Acará', 00206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Afuá', 00305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Água Azul do Norte', 00347;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Alenquer', 00404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Almeirim', 00503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Altamira', 00602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Anajás', 00701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Ananindeua', 00800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Anapu', 00859;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Augusto Corrêa', 00909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Aurora do Pará', 00958;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Aveiro', 01006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Bagre', 01105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Baião', 01204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Bannach', 01253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Barcarena', 01303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Belém', 01402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Belterra', 01451;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Benevides', 01501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Bom Jesus do Tocantins', 01576;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Bonito', 01600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Bragança', 01709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Brasil Novo', 01725;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Brejo Grande do Araguaia', 01758;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Breu Branco', 01782;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Breves', 01808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Bujaru', 01907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Cachoeira do Arari', 02004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Cachoeira do Piriá', 01956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Cametá', 02103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Canaã dos Carajás', 02152;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Capanema', 02202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Capitão Poço', 02301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Castanhal', 02400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Chaves', 02509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Colares', 02608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Conceição do Araguaia', 02707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Concórdia do Pará', 02756;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Cumaru do Norte', 02764;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Curionópolis', 02772;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Curralinho', 02806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Curuá', 02855;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Curuçá', 02905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Dom Eliseu', 02939;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Eldorado do Carajás', 02954;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Faro', 03002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Floresta do Araguaia', 03044;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Garrafão do Norte', 03077;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Goianésia do Pará', 03093;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Gurupá', 03101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Igarapé-Açu', 03200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Igarapé-Miri', 03309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Inhangapi', 03408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Ipixuna do Pará', 03457;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Irituia', 03507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Itaituba', 03606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Itupiranga', 03705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Jacareacanga', 03754;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Jacundá', 03804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Juruti', 03903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Limoeiro do Ajuru', 04000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Mãe do Rio', 04059;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Magalhães Barata', 04109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Marabá', 04208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Maracanã', 04307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Marapanim', 04406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Marituba', 04422;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Medicilândia', 04455;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Melgaço', 04505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Mocajuba', 04604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Moju', 04703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Mojuí dos Campos', 04752;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Monte Alegre', 04802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Muaná', 04901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Nova Esperança do Piriá', 04950;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Nova Ipixuna', 04976;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Nova Timboteua', 05007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Novo Progresso', 05031;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Novo Repartimento', 05064;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Óbidos', 05106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Oeiras do Pará', 05205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Oriximiná', 05304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Ourém', 05403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Ourilândia do Norte', 05437;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Pacajá', 05486;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Palestina do Pará', 05494;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Paragominas', 05502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Parauapebas', 05536;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Pau D''Arco', 05551;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Peixe-Boi', 05601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Piçarra', 05635;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Placas', 05650;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Ponta de Pedras', 05700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Portel', 05809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Porto de Moz', 05908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Prainha', 06005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Primavera', 06104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Quatipuru', 06112;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Redenção', 06138;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Rio Maria', 06161;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Rondon do Pará', 06187;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Rurópolis', 06195;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Salinópolis', 06203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Salvaterra', 06302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Santa Bárbara do Pará', 06351;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Santa Cruz do Arari', 06401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Santa Izabel do Pará', 06500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Santa Luzia do Pará', 06559;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Santa Maria das Barreiras', 06583;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Santa Maria do Pará', 06609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Santana do Araguaia', 06708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Santarém', 06807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Santarém Novo', 06906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Santo Antônio do Tauá', 07003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'São Caetano de Odivelas', 07102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'São Domingos do Araguaia', 07151;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'São Domingos do Capim', 07201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'São Félix do Xingu', 07300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'São Francisco do Pará', 07409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'São Geraldo do Araguaia', 07458;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'São João da Ponta', 07466;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'São João de Pirabas', 07474;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'São João do Araguaia', 07508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'São Miguel do Guamá', 07607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'São Sebastião da Boa Vista', 07706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Sapucaia', 07755;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Senador José Porfírio', 07805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Soure', 07904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Tailândia', 07953;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Terra Alta', 07961;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Terra Santa', 07979;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Tomé-Açu', 08001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Tracuateua', 08035;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Trairão', 08050;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Tucumã', 08084;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Tucuruí', 08100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Ulianópolis', 08126;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Uruará', 08159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Vigia', 08209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Viseu', 08308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Vitória do Xingu', 08357;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 15), 'Xinguara', 08407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Amapá', 00105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Calçoene', 00204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Cutias', 00212;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Ferreira Gomes', 00238;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Itaubal', 00253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Laranjal do Jari', 00279;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Macapá', 00303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Mazagão', 00402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Oiapoque', 00501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Pedra Branca do Amapari', 00154;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Porto Grande', 00535;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Pracuúba', 00550;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Santana', 00600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Serra do Navio', 00055;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Tartarugalzinho', 00709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 16), 'Vitória do Jari', 00808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Abreulândia', 00251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Aguiarnópolis', 00301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Aliança do Tocantins', 00350;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Almas', 00400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Alvorada', 00707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Ananás', 01002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Angico', 01051;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Aparecida do Rio Negro', 01101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Aragominas', 01309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Araguacema', 01903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Araguaçu', 02000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Araguaína', 02109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Araguanã', 02158;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Araguatins', 02208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Arapoema', 02307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Arraias', 02406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Augustinópolis', 02554;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Aurora do Tocantins', 02703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Axixá do Tocantins', 02901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Babaçulândia', 03008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Bandeirantes do Tocantins', 03057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Barra do Ouro', 03073;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Barrolândia', 03107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Bernardo Sayão', 03206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Bom Jesus do Tocantins', 03305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Brasilândia do Tocantins', 03602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Brejinho de Nazaré', 03701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Buriti do Tocantins', 03800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Cachoeirinha', 03826;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Campos Lindos', 03842;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Cariri do Tocantins', 03867;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Carmolândia', 03883;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Carrasco Bonito', 03891;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Caseara', 03909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Centenário', 04105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Chapada da Natividade', 05102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Chapada de Areia', 04600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Colinas do Tocantins', 05508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Colméia', 16703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Combinado', 05557;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Conceição do Tocantins', 05607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Couto Magalhães', 06001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Cristalândia', 06100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Crixás do Tocantins', 06258;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Darcinópolis', 06506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Dianópolis', 07009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Divinópolis do Tocantins', 07108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Dois Irmãos do Tocantins', 07207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Dueré', 07306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Esperantina', 07405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Fátima', 07553;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Figueirópolis', 07652;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Filadélfia', 07702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Formoso do Araguaia', 08205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Goianorte', 08304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Goiatins', 09005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Guaraí', 09302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Gurupi', 09500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Ipueiras', 09807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Itacajá', 10508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Itaguatins', 10706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Itapiratins', 10904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Itaporã do Tocantins', 11100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Jaú do Tocantins', 11506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Juarina', 11803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Lagoa da Confusão', 11902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Lagoa do Tocantins', 11951;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Lajeado', 12009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Lavandeira', 12157;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Lizarda', 12405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Luzinópolis', 12454;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Marianópolis do Tocantins', 12504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Mateiros', 12702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Maurilândia do Tocantins', 12801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Miracema do Tocantins', 13205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Miranorte', 13304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Monte do Carmo', 13601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Monte Santo do Tocantins', 13700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Muricilândia', 13957;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Natividade', 14203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Nazaré', 14302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Nova Olinda', 14880;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Nova Rosalândia', 15002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Novo Acordo', 15101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Novo Alegre', 15150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Novo Jardim', 15259;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Oliveira de Fátima', 15507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Palmas', 21000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Palmeirante', 15705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Palmeiras do Tocantins', 13809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Palmeirópolis', 15754;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Paraíso do Tocantins', 16109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Paranã', 16208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Pau D''Arco', 16307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Pedro Afonso', 16505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Peixe', 16604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Pequizeiro', 16653;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Pindorama do Tocantins', 17008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Piraquê', 17206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Pium', 17503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Ponte Alta do Bom Jesus', 17800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Ponte Alta do Tocantins', 17909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Porto Alegre do Tocantins', 18006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Porto Nacional', 18204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Praia Norte', 18303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Presidente Kennedy', 18402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Pugmil', 18451;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Recursolândia', 18501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Riachinho', 18550;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Rio da Conceição', 18659;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Rio dos Bois', 18709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Rio Sono', 18758;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Sampaio', 18808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Sandolândia', 18840;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Santa Fé do Araguaia', 18865;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Santa Maria do Tocantins', 18881;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Santa Rita do Tocantins', 18899;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Santa Rosa do Tocantins', 18907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Santa Tereza do Tocantins', 19004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Santa Terezinha do Tocantins', 20002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'São Bento do Tocantins', 20101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'São Félix do Tocantins', 20150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'São Miguel do Tocantins', 20200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'São Salvador do Tocantins', 20259;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'São Sebastião do Tocantins', 20309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'São Valério', 20499;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Silvanópolis', 20655;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Sítio Novo do Tocantins', 20804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Sucupira', 20853;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Tabocão', 08254;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Taguatinga', 20903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Taipas do Tocantins', 20937;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Talismã', 20978;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Tocantínia', 21109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Tocantinópolis', 21208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Tupirama', 21257;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Tupiratins', 21307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Wanderlândia', 22081;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 17), 'Xambioá', 22107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Açailândia', 00055;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Afonso Cunha', 00105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Água Doce do Maranhão', 00154;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Alcântara', 00204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Aldeias Altas', 00303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Altamira do Maranhão', 00402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Alto Alegre do Maranhão', 00436;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Alto Alegre do Pindaré', 00477;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Alto Parnaíba', 00501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Amapá do Maranhão', 00550;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Amarante do Maranhão', 00600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Anajatuba', 00709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Anapurus', 00808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Apicum-Açu', 00832;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Araguanã', 00873;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Araioses', 00907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Arame', 00956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Arari', 01004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Axixá', 01103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Bacabal', 01202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Bacabeira', 01251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Bacuri', 01301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Bacurituba', 01350;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Balsas', 01400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Barão de Grajaú', 01509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Barra do Corda', 01608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Barreirinhas', 01707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Bela Vista do Maranhão', 01772;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Belágua', 01731;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Benedito Leite', 01806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Bequimão', 01905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Bernardo do Mearim', 01939;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Boa Vista do Gurupi', 01970;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Bom Jardim', 02002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Bom Jesus das Selvas', 02036;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Bom Lugar', 02077;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Brejo', 02101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Brejo de Areia', 02150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Buriti', 02200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Buriti Bravo', 02309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Buriticupu', 02325;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Buritirana', 02358;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Cachoeira Grande', 02374;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Cajapió', 02408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Cajari', 02507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Campestre do Maranhão', 02556;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Cândido Mendes', 02606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Cantanhede', 02705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Capinzal do Norte', 02754;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Carolina', 02804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Carutapera', 02903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Caxias', 03000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Cedral', 03109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Central do Maranhão', 03125;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Centro do Guilherme', 03158;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Centro Novo do Maranhão', 03174;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Chapadinha', 03208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Cidelândia', 03257;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Codó', 03307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Coelho Neto', 03406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Colinas', 03505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Conceição do Lago-Açu', 03554;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Coroatá', 03604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Cururupu', 03703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Davinópolis', 03752;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Dom Pedro', 03802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Duque Bacelar', 03901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Esperantinópolis', 04008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Estreito', 04057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Feira Nova do Maranhão', 04073;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Fernando Falcão', 04081;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Formosa da Serra Negra', 04099;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Fortaleza dos Nogueiras', 04107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Fortuna', 04206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Godofredo Viana', 04305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Gonçalves Dias', 04404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Governador Archer', 04503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Governador Edison Lobão', 04552;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Governador Eugênio Barros', 04602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Governador Luiz Rocha', 04628;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Governador Newton Bello', 04651;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Governador Nunes Freire', 04677;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Graça Aranha', 04701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Grajaú', 04800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Guimarães', 04909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Humberto de Campos', 05005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Icatu', 05104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Igarapé do Meio', 05153;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Igarapé Grande', 05203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Imperatriz', 05302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Itaipava do Grajaú', 05351;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Itapecuru Mirim', 05401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Itinga do Maranhão', 05427;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Jatobá', 05450;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Jenipapo dos Vieiras', 05476;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'João Lisboa', 05500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Joselândia', 05609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Junco do Maranhão', 05658;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Lago da Pedra', 05708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Lago do Junco', 05807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Lago dos Rodrigues', 05948;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Lago Verde', 05906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Lagoa do Mato', 05922;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Lagoa Grande do Maranhão', 05963;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Lajeado Novo', 05989;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Lima Campos', 06003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Loreto', 06102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Luís Domingues', 06201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Magalhães de Almeida', 06300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Maracaçumé', 06326;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Marajá do Sena', 06359;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Maranhãozinho', 06375;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Mata Roma', 06409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Matinha', 06508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Matões', 06607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Matões do Norte', 06631;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Milagres do Maranhão', 06672;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Mirador', 06706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Miranda do Norte', 06755;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Mirinzal', 06805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Monção', 06904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Montes Altos', 07001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Morros', 07100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Nina Rodrigues', 07209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Nova Colinas', 07258;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Nova Iorque', 07308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Nova Olinda do Maranhão', 07357;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Olho d''Água das Cunhãs', 07407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Olinda Nova do Maranhão', 07456;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Paço do Lumiar', 07506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Palmeirândia', 07605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Paraibano', 07704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Parnarama', 07803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Passagem Franca', 07902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Pastos Bons', 08009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Paulino Neves', 08058;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Paulo Ramos', 08108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Pedreiras', 08207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Pedro do Rosário', 08256;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Penalva', 08306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Peri Mirim', 08405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Peritoró', 08454;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Pindaré-Mirim', 08504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Pinheiro', 08603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Pio XII', 08702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Pirapemas', 08801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Poção de Pedras', 08900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Porto Franco', 09007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Porto Rico do Maranhão', 09056;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Presidente Dutra', 09106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Presidente Juscelino', 09205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Presidente Médici', 09239;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Presidente Sarney', 09270;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Presidente Vargas', 09304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Primeira Cruz', 09403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Raposa', 09452;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Riachão', 09502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Ribamar Fiquene', 09551;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Rosário', 09601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Sambaíba', 09700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Santa Filomena do Maranhão', 09759;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Santa Helena', 09809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Santa Inês', 09908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Santa Luzia', 10005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Santa Luzia do Paruá', 10039;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Santa Quitéria do Maranhão', 10104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Santa Rita', 10203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Santana do Maranhão', 10237;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Santo Amaro do Maranhão', 10278;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Santo Antônio dos Lopes', 10302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Benedito do Rio Preto', 10401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Bento', 10500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Bernardo', 10609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Domingos do Azeitão', 10658;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Domingos do Maranhão', 10708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Félix de Balsas', 10807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Francisco do Brejão', 10856;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Francisco do Maranhão', 10906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São João Batista', 11003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São João do Carú', 11029;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São João do Paraíso', 11052;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São João do Soter', 11078;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São João dos Patos', 11102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São José de Ribamar', 11201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São José dos Basílios', 11250;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Luís', 11300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Luís Gonzaga do Maranhão', 11409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Mateus do Maranhão', 11508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Pedro da Água Branca', 11532;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Pedro dos Crentes', 11573;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Raimundo das Mangabeiras', 11607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Raimundo do Doca Bezerra', 11631;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Roberto', 11672;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'São Vicente Ferrer', 11706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Satubinha', 11722;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Senador Alexandre Costa', 11748;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Senador La Rocque', 11763;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Serrano do Maranhão', 11789;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Sítio Novo', 11805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Sucupira do Norte', 11904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Sucupira do Riachão', 11953;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Tasso Fragoso', 12001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Timbiras', 12100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Timon', 12209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Trizidela do Vale', 12233;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Tufilândia', 12274;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Tuntum', 12308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Turiaçu', 12407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Turilândia', 12456;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Tutóia', 12506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Urbano Santos', 12605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Vargem Grande', 12704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Viana', 12803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Vila Nova dos Martírios', 12852;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Vitória do Mearim', 12902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Vitorino Freire', 13009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 21), 'Zé Doca', 14007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Acauã', 00053;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Agricolândia', 00103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Água Branca', 00202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Alagoinha do Piauí', 00251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Alegrete do Piauí', 00277;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Alto Longá', 00301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Altos', 00400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Alvorada do Gurguéia', 00459;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Amarante', 00509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Angical do Piauí', 00608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Anísio de Abreu', 00707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Antônio Almeida', 00806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Aroazes', 00905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Aroeiras do Itaim', 00954;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Arraial', 01002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Assunção do Piauí', 01051;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Avelino Lopes', 01101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Baixa Grande do Ribeiro', 01150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Barra D''Alcântara', 01176;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Barras', 01200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Barreiras do Piauí', 01309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Barro Duro', 01408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Batalha', 01507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Bela Vista do Piauí', 01556;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Belém do Piauí', 01572;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Beneditinos', 01606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Bertolínia', 01705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Betânia do Piauí', 01739;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Boa Hora', 01770;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Bocaina', 01804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Bom Jesus', 01903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Bom Princípio do Piauí', 01919;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Bonfim do Piauí', 01929;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Boqueirão do Piauí', 01945;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Brasileira', 01960;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Brejo do Piauí', 01988;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Buriti dos Lopes', 02000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Buriti dos Montes', 02026;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Cabeceiras do Piauí', 02059;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Cajazeiras do Piauí', 02075;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Cajueiro da Praia', 02083;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Caldeirão Grande do Piauí', 02091;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Campinas do Piauí', 02109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Campo Alegre do Fidalgo', 02117;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Campo Grande do Piauí', 02133;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Campo Largo do Piauí', 02174;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Campo Maior', 02208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Canavieira', 02251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Canto do Buriti', 02307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Capitão de Campos', 02406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Capitão Gervásio Oliveira', 02455;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Caracol', 02505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Caraúbas do Piauí', 02539;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Caridade do Piauí', 02554;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Castelo do Piauí', 02604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Caxingó', 02653;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Cocal', 02703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Cocal de Telha', 02711;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Cocal dos Alves', 02729;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Coivaras', 02737;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Colônia do Gurguéia', 02752;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Colônia do Piauí', 02778;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Conceição do Canindé', 02802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Coronel José Dias', 02851;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Corrente', 02901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Cristalândia do Piauí', 03008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Cristino Castro', 03107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Curimatá', 03206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Currais', 03230;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Curral Novo do Piauí', 03271;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Curralinhos', 03255;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Demerval Lobão', 03305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Dirceu Arcoverde', 03354;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Dom Expedito Lopes', 03404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Dom Inocêncio', 03453;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Domingos Mourão', 03420;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Elesbão Veloso', 03503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Eliseu Martins', 03602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Esperantina', 03701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Fartura do Piauí', 03750;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Flores do Piauí', 03800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Floresta do Piauí', 03859;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Floriano', 03909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Francinópolis', 04006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Francisco Ayres', 04105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Francisco Macedo', 04154;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Francisco Santos', 04204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Fronteiras', 04303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Geminiano', 04352;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Gilbués', 04402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Guadalupe', 04501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Guaribas', 04550;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Hugo Napoleão', 04600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Ilha Grande', 04659;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Inhuma', 04709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Ipiranga do Piauí', 04808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Isaías Coelho', 04907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Itainópolis', 05003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Itaueira', 05102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Jacobina do Piauí', 05151;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Jaicós', 05201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Jardim do Mulato', 05250;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Jatobá do Piauí', 05276;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Jerumenha', 05300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'João Costa', 05359;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Joaquim Pires', 05409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Joca Marques', 05458;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'José de Freitas', 05508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Juazeiro do Piauí', 05516;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Júlio Borges', 05524;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Jurema', 05532;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Lagoa Alegre', 05557;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Lagoa de São Francisco', 05573;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Lagoa do Barro do Piauí', 05565;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Lagoa do Piauí', 05581;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Lagoa do Sítio', 05599;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Lagoinha do Piauí', 05540;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Landri Sales', 05607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Luís Correia', 05706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Luzilândia', 05805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Madeiro', 05854;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Manoel Emídio', 05904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Marcolândia', 05953;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Marcos Parente', 06001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Massapê do Piauí', 06050;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Matias Olímpio', 06100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Miguel Alves', 06209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Miguel Leão', 06308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Milton Brandão', 06357;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Monsenhor Gil', 06407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Monsenhor Hipólito', 06506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Monte Alegre do Piauí', 06605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Morro Cabeça no Tempo', 06654;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Morro do Chapéu do Piauí', 06670;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Murici dos Portelas', 06696;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Nazaré do Piauí', 06704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Nazária', 06720;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Nossa Senhora de Nazaré', 06753;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Nossa Senhora dos Remédios', 06803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Nova Santa Rita', 07959;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Novo Oriente do Piauí', 06902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Novo Santo Antônio', 06951;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Oeiras', 07009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Olho D''Água do Piauí', 07108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Padre Marcos', 07207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Paes Landim', 07306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Pajeú do Piauí', 07355;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Palmeira do Piauí', 07405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Palmeirais', 07504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Paquetá', 07553;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Parnaguá', 07603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Parnaíba', 07702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Passagem Franca do Piauí', 07751;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Patos do Piauí', 07777;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Pau D''Arco do Piauí', 07793;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Paulistana', 07801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Pavussu', 07850;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Pedro II', 07900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Pedro Laurentino', 07934;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Picos', 08007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Pimenteiras', 08106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Pio IX', 08205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Piracuruca', 08304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Piripiri', 08403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Porto', 08502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Porto Alegre do Piauí', 08551;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Prata do Piauí', 08601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Queimada Nova', 08650;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Redenção do Gurguéia', 08700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Regeneração', 08809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Riacho Frio', 08858;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Ribeira do Piauí', 08874;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Ribeiro Gonçalves', 08908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Rio Grande do Piauí', 09005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Santa Cruz do Piauí', 09104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Santa Cruz dos Milagres', 09153;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Santa Filomena', 09203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Santa Luz', 09302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Santa Rosa do Piauí', 09377;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Santana do Piauí', 09351;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Santo Antônio de Lisboa', 09401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Santo Antônio dos Milagres', 09450;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Santo Inácio do Piauí', 09500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Braz do Piauí', 09559;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Félix do Piauí', 09609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Francisco de Assis do Piauí', 09658;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Francisco do Piauí', 09708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Gonçalo do Gurguéia', 09757;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Gonçalo do Piauí', 09807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São João da Canabrava', 09856;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São João da Fronteira', 09872;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São João da Serra', 09906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São João da Varjota', 09955;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São João do Arraial', 09971;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São João do Piauí', 10003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São José do Divino', 10052;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São José do Peixe', 10102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São José do Piauí', 10201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Julião', 10300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Lourenço do Piauí', 10359;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Luis do Piauí', 10375;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Miguel da Baixa Grande', 10383;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Miguel do Fidalgo', 10391;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Miguel do Tapuio', 10409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Pedro do Piauí', 10508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'São Raimundo Nonato', 10607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Sebastião Barros', 10623;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Sebastião Leal', 10631;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Sigefredo Pacheco', 10656;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Simões', 10706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Simplício Mendes', 10805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Socorro do Piauí', 10904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Sussuapara', 10938;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Tamboril do Piauí', 10953;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Tanque do Piauí', 10979;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Teresina', 11001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'União', 11100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Uruçuí', 11209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Valença do Piauí', 11308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Várzea Branca', 11357;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Várzea Grande', 11407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Vera Mendes', 11506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Vila Nova do Piauí', 11605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 22), 'Wall Ferraz', 11704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Abaiara', 00101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Acarape', 00150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Acaraú', 00200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Acopiara', 00309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Aiuaba', 00408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Alcântaras', 00507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Altaneira', 00606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Alto Santo', 00705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Amontada', 00754;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Antonina do Norte', 00804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Apuiarés', 00903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Aquiraz', 01000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Aracati', 01109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Aracoiaba', 01208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Ararendá', 01257;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Araripe', 01307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Aratuba', 01406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Arneiroz', 01505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Assaré', 01604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Aurora', 01703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Baixio', 01802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Banabuiú', 01851;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Barbalha', 01901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Barreira', 01950;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Barro', 02008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Barroquinha', 02057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Baturité', 02107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Beberibe', 02206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Bela Cruz', 02305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Boa Viagem', 02404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Brejo Santo', 02503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Camocim', 02602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Campos Sales', 02701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Canindé', 02800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Capistrano', 02909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Caridade', 03006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Cariré', 03105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Caririaçu', 03204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Cariús', 03303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Carnaubal', 03402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Cascavel', 03501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Catarina', 03600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Catunda', 03659;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Caucaia', 03709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Cedro', 03808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Chaval', 03907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Choró', 03931;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Chorozinho', 03956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Coreaú', 04004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Crateús', 04103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Crato', 04202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Croatá', 04236;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Cruz', 04251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Deputado Irapuan Pinheiro', 04269;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Ereré', 04277;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Eusébio', 04285;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Farias Brito', 04301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Forquilha', 04350;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Fortaleza', 04400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Fortim', 04459;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Frecheirinha', 04509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'General Sampaio', 04608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Graça', 04657;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Granja', 04707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Granjeiro', 04806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Groaíras', 04905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Guaiúba', 04954;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Guaraciaba do Norte', 05001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Guaramiranga', 05100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Hidrolândia', 05209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Horizonte', 05233;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Ibaretama', 05266;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Ibiapina', 05308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Ibicuitinga', 05332;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Icapuí', 05357;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Icó', 05407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Iguatu', 05506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Independência', 05605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Ipaporanga', 05654;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Ipaumirim', 05704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Ipu', 05803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Ipueiras', 05902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Iracema', 06009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Irauçuba', 06108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Itaiçaba', 06207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Itaitinga', 06256;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Itapajé', 06306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Itapipoca', 06405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Itapiúna', 06504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Itarema', 06553;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Itatira', 06603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Jaguaretama', 06702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Jaguaribara', 06801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Jaguaribe', 06900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Jaguaruana', 07007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Jardim', 07106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Jati', 07205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Jijoca de Jericoacoara', 07254;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Juazeiro do Norte', 07304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Jucás', 07403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Lavras da Mangabeira', 07502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Limoeiro do Norte', 07601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Madalena', 07635;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Maracanaú', 07650;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Maranguape', 07700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Marco', 07809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Martinópole', 07908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Massapê', 08005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Mauriti', 08104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Meruoca', 08203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Milagres', 08302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Milhã', 08351;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Miraíma', 08377;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Missão Velha', 08401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Mombaça', 08500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Monsenhor Tabosa', 08609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Morada Nova', 08708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Moraújo', 08807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Morrinhos', 08906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Mucambo', 09003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Mulungu', 09102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Nova Olinda', 09201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Nova Russas', 09300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Novo Oriente', 09409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Ocara', 09458;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Orós', 09508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Pacajus', 09607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Pacatuba', 09706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Pacoti', 09805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Pacujá', 09904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Palhano', 10001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Palmácia', 10100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Paracuru', 10209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Paraipaba', 10258;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Parambu', 10308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Paramoti', 10407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Pedra Branca', 10506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Penaforte', 10605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Pentecoste', 10704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Pereiro', 10803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Pindoretama', 10852;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Piquet Carneiro', 10902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Pires Ferreira', 10951;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Poranga', 11009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Porteiras', 11108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Potengi', 11207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Potiretama', 11231;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Quiterianópolis', 11264;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Quixadá', 11306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Quixelô', 11355;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Quixeramobim', 11405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Quixeré', 11504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Redenção', 11603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Reriutaba', 11702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Russas', 11801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Saboeiro', 11900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Salitre', 11959;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Santa Quitéria', 12205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Santana do Acaraú', 12007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Santana do Cariri', 12106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'São Benedito', 12304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'São Gonçalo do Amarante', 12403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'São João do Jaguaribe', 12502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'São Luís do Curu', 12601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Senador Pompeu', 12700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Senador Sá', 12809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Sobral', 12908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Solonópole', 13005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Tabuleiro do Norte', 13104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Tamboril', 13203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Tarrafas', 13252;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Tauá', 13302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Tejuçuoca', 13351;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Tianguá', 13401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Trairi', 13500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Tururu', 13559;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Ubajara', 13609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Umari', 13708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Umirim', 13757;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Uruburetama', 13807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Uruoca', 13906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Varjota', 13955;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Várzea Alegre', 14003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 23), 'Viçosa do Ceará', 14102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Acari', 00109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Açu', 00208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Afonso Bezerra', 00307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Água Nova', 00406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Alexandria', 00505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Almino Afonso', 00604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Alto do Rodrigues', 00703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Angicos', 00802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Antônio Martins', 00901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Apodi', 01008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Areia Branca', 01107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Arês', 01206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Baía Formosa', 01404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Baraúna', 01453;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Barcelona', 01503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Bento Fernandes', 01602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Bodó', 01651;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Bom Jesus', 01701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Brejinho', 01800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Caiçara do Norte', 01859;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Caiçara do Rio do Vento', 01909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Caicó', 02006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Campo Grande', 01305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Campo Redondo', 02105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Canguaretama', 02204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Caraúbas', 02303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Carnaúba dos Dantas', 02402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Carnaubais', 02501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Ceará-Mirim', 02600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Cerro Corá', 02709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Coronel Ezequiel', 02808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Coronel João Pessoa', 02907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Cruzeta', 03004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Currais Novos', 03103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Doutor Severiano', 03202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Encanto', 03301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Equador', 03400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Espírito Santo', 03509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Extremoz', 03608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Felipe Guerra', 03707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Fernando Pedroza', 03756;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Florânia', 03806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Francisco Dantas', 03905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Frutuoso Gomes', 04002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Galinhos', 04101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Goianinha', 04200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Governador Dix-Sept Rosado', 04309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Grossos', 04408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Guamaré', 04507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Ielmo Marinho', 04606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Ipanguaçu', 04705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Ipueira', 04804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Itajá', 04853;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Itaú', 04903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Jaçanã', 05009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Jandaíra', 05108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Janduís', 05207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Januário Cicco', 05306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Japi', 05405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Jardim de Angicos', 05504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Jardim de Piranhas', 05603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Jardim do Seridó', 05702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'João Câmara', 05801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'João Dias', 05900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'José da Penha', 06007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Jucurutu', 06106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Jundiá', 06155;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Lagoa d''Anta', 06205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Lagoa de Pedras', 06304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Lagoa de Velhos', 06403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Lagoa Nova', 06502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Lagoa Salgada', 06601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Lajes', 06700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Lajes Pintadas', 06809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Lucrécia', 06908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Luís Gomes', 07005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Macaíba', 07104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Macau', 07203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Major Sales', 07252;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Marcelino Vieira', 07302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Martins', 07401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Maxaranguape', 07500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Messias Targino', 07609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Montanhas', 07708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Monte Alegre', 07807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Monte das Gameleiras', 07906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Mossoró', 08003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Natal', 08102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Nísia Floresta', 08201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Nova Cruz', 08300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Olho d''Água do Borges', 08409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Ouro Branco', 08508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Paraná', 08607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Paraú', 08706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Parazinho', 08805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Parelhas', 08904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Parnamirim', 03251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Passa e Fica', 09100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Passagem', 09209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Patu', 09308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Pau dos Ferros', 09407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Pedra Grande', 09506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Pedra Preta', 09605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Pedro Avelino', 09704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Pedro Velho', 09803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Pendências', 09902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Pilões', 10009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Poço Branco', 10108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Portalegre', 10207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Porto do Mangue', 10256;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Pureza', 10405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Rafael Fernandes', 10504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Rafael Godeiro', 10603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Riacho da Cruz', 10702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Riacho de Santana', 10801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Riachuelo', 10900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Rio do Fogo', 08953;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Rodolfo Fernandes', 11007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Ruy Barbosa', 11106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Santa Cruz', 11205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Santa Maria', 09332;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Santana do Matos', 11403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Santana do Seridó', 11429;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Santo Antônio', 11502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São Bento do Norte', 11601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São Bento do Trairí', 11700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São Fernando', 11809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São Francisco do Oeste', 11908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São Gonçalo do Amarante', 12005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São João do Sabugi', 12104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São José de Mipibu', 12203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São José do Campestre', 12302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São José do Seridó', 12401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São Miguel', 12500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São Miguel do Gostoso', 12559;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São Paulo do Potengi', 12609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São Pedro', 12708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São Rafael', 12807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São Tomé', 12906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'São Vicente', 13003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Senador Elói de Souza', 13102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Senador Georgino Avelino', 13201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Serra Caiada', 10306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Serra de São Bento', 13300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Serra do Mel', 13359;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Serra Negra do Norte', 13409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Serrinha', 13508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Serrinha dos Pintos', 13557;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Severiano Melo', 13607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Sítio Novo', 13706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Taboleiro Grande', 13805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Taipu', 13904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Tangará', 14001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Tenente Ananias', 14100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Tenente Laurentino Cruz', 14159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Tibau', 11056;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Tibau do Sul', 14209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Timbaúba dos Batistas', 14308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Touros', 14407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Triunfo Potiguar', 14456;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Umarizal', 14506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Upanema', 14605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Várzea', 14704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Venha-Ver', 14753;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Vera Cruz', 14803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Viçosa', 14902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 24), 'Vila Flor', 15008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Água Branca', 00106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Aguiar', 00205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Alagoa Grande', 00304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Alagoa Nova', 00403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Alagoinha', 00502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Alcantil', 00536;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Algodão de Jandaíra', 00577;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Alhandra', 00601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Amparo', 00734;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Aparecida', 00775;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Araçagi', 00809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Arara', 00908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Araruna', 01005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Areia', 01104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Areia de Baraúnas', 01153;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Areial', 01203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Aroeiras', 01302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Assunção', 01351;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Baía da Traição', 01401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Bananeiras', 01500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Baraúna', 01534;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Barra de Santa Rosa', 01609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Barra de Santana', 01575;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Barra de São Miguel', 01708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Bayeux', 01807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Belém', 01906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Belém do Brejo do Cruz', 02003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Bernardino Batista', 02052;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Boa Ventura', 02102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Boa Vista', 02151;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Bom Jesus', 02201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Bom Sucesso', 02300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Bonito de Santa Fé', 02409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Boqueirão', 02508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Borborema', 02706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Brejo do Cruz', 02805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Brejo dos Santos', 02904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Caaporã', 03001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Cabaceiras', 03100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Cabedelo', 03209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Cachoeira dos Índios', 03308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Cacimba de Areia', 03407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Cacimba de Dentro', 03506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Cacimbas', 03555;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Caiçara', 03605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Cajazeiras', 03704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Cajazeirinhas', 03753;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Caldas Brandão', 03803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Camalaú', 03902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Campina Grande', 04009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Capim', 04033;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Caraúbas', 04074;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Carrapateira', 04108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Casserengue', 04157;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Catingueira', 04207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Catolé do Rocha', 04306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Caturité', 04355;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Conceição', 04405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Condado', 04504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Conde', 04603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Congo', 04702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Coremas', 04801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Coxixola', 04850;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Cruz do Espírito Santo', 04900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Cubati', 05006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Cuité', 05105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Cuité de Mamanguape', 05238;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Cuitegi', 05204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Curral de Cima', 05279;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Curral Velho', 05303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Damião', 05352;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Desterro', 05402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Diamante', 05600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Dona Inês', 05709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Duas Estradas', 05808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Emas', 05907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Esperança', 06004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Fagundes', 06103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Frei Martinho', 06202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Gado Bravo', 06251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Guarabira', 06301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Gurinhém', 06400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Gurjão', 06509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Ibiara', 06608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Igaracy', 02607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Imaculada', 06707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Ingá', 06806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Itabaiana', 06905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Itaporanga', 07002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Itapororoca', 07101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Itatuba', 07200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Jacaraú', 07309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Jericó', 07408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'João Pessoa', 07507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Joca Claudino', 13653;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Juarez Távora', 07606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Juazeirinho', 07705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Junco do Seridó', 07804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Juripiranga', 07903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Juru', 08000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Lagoa', 08109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Lagoa de Dentro', 08208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Lagoa Seca', 08307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Lastro', 08406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Livramento', 08505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Logradouro', 08554;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Lucena', 08604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Mãe d''Água', 08703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Malta', 08802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Mamanguape', 08901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Manaíra', 09008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Marcação', 09057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Mari', 09107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Marizópolis', 09156;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Massaranduba', 09206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Mataraca', 09305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Matinhas', 09339;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Mato Grosso', 09370;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Maturéia', 09396;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Mogeiro', 09404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Montadas', 09503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Monte Horebe', 09602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Monteiro', 09701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Mulungu', 09800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Natuba', 09909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Nazarezinho', 10006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Nova Floresta', 10105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Nova Olinda', 10204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Nova Palmeira', 10303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Olho d''Água', 10402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Olivedos', 10501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Ouro Velho', 10600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Parari', 10659;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Passagem', 10709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Patos', 10808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Paulista', 10907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Pedra Branca', 11004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Pedra Lavrada', 11103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Pedras de Fogo', 11202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Pedro Régis', 12721;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Piancó', 11301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Picuí', 11400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Pilar', 11509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Pilões', 11608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Pilõezinhos', 11707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Pirpirituba', 11806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Pitimbu', 11905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Pocinhos', 12002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Poço Dantas', 12036;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Poço de José de Moura', 12077;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Pombal', 12101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Prata', 12200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Princesa Isabel', 12309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Puxinanã', 12408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Queimadas', 12507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Quixaba', 12606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Remígio', 12705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Riachão', 12747;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Riachão do Bacamarte', 12754;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Riachão do Poço', 12762;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Riacho de Santo Antônio', 12788;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Riacho dos Cavalos', 12804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Rio Tinto', 12903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Salgadinho', 13000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Salgado de São Félix', 13109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Santa Cecília', 13158;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Santa Cruz', 13208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Santa Helena', 13307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Santa Inês', 13356;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Santa Luzia', 13406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Santa Rita', 13703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Santa Teresinha', 13802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Santana de Mangueira', 13505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Santana dos Garrotes', 13604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Santo André', 13851;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São Bentinho', 13927;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São Bento', 13901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São Domingos', 13968;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São Domingos do Cariri', 13943;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São Francisco', 13984;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São João do Cariri', 14008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São João do Rio do Peixe', 00700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São João do Tigre', 14107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São José da Lagoa Tapada', 14206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São José de Caiana', 14305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São José de Espinharas', 14404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São José de Piranhas', 14503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São José de Princesa', 14552;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São José do Bonfim', 14602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São José do Brejo do Cruz', 14651;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São José do Sabugi', 14701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São José dos Cordeiros', 14800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São José dos Ramos', 14453;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São Mamede', 14909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São Miguel de Taipu', 15005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São Sebastião de Lagoa de Roça', 15104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São Sebastião do Umbuzeiro', 15203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'São Vicente do Seridó', 15401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Sapé', 15302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Serra Branca', 15500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Serra da Raiz', 15609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Serra Grande', 15708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Serra Redonda', 15807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Serraria', 15906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Sertãozinho', 15930;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Sobrado', 15971;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Solânea', 16003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Soledade', 16102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Sossêgo', 16151;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Sousa', 16201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Sumé', 16300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Tacima', 16409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Taperoá', 16508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Tavares', 16607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Teixeira', 16706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Tenório', 16755;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Triunfo', 16805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Uiraúna', 16904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Umbuzeiro', 17001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Várzea', 17100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Vieirópolis', 17209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Vista Serrana', 05501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 25), 'Zabelê', 17407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Abreu e Lima', 00054;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Afogados da Ingazeira', 00104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Afrânio', 00203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Agrestina', 00302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Água Preta', 00401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Águas Belas', 00500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Alagoinha', 00609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Aliança', 00708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Altinho', 00807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Amaraji', 00906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Angelim', 01003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Araçoiaba', 01052;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Araripina', 01102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Arcoverde', 01201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Barra de Guabiraba', 01300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Barreiros', 01409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Belém de Maria', 01508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Belém do São Francisco', 01607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Belo Jardim', 01706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Betânia', 01805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Bezerros', 01904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Bodocó', 02001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Bom Conselho', 02100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Bom Jardim', 02209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Bonito', 02308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Brejão', 02407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Brejinho', 02506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Brejo da Madre de Deus', 02605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Buenos Aires', 02704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Buíque', 02803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Cabo de Santo Agostinho', 02902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Cabrobó', 03009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Cachoeirinha', 03108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Caetés', 03207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Calçado', 03306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Calumbi', 03405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Camaragibe', 03454;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Camocim de São Félix', 03504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Camutanga', 03603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Canhotinho', 03702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Capoeiras', 03801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Carnaíba', 03900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Carnaubeira da Penha', 03926;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Carpina', 04007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Caruaru', 04106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Casinhas', 04155;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Catende', 04205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Cedro', 04304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Chã de Alegria', 04403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Chã Grande', 04502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Condado', 04601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Correntes', 04700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Cortês', 04809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Cumaru', 04908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Cupira', 05004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Custódia', 05103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Dormentes', 05152;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Escada', 05202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Exu', 05301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Feira Nova', 05400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Fernando de Noronha', 05459;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Ferreiros', 05509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Flores', 05608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Floresta', 05707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Frei Miguelinho', 05806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Gameleira', 05905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Garanhuns', 06002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Glória do Goitá', 06101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Goiana', 06200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Granito', 06309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Gravatá', 06408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Iati', 06507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Ibimirim', 06606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Ibirajuba', 06705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Igarassu', 06804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Iguaracy', 06903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Ilha de Itamaracá', 07604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Inajá', 07000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Ingazeira', 07109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Ipojuca', 07208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Ipubi', 07307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Itacuruba', 07406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Itaíba', 07505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Itambé', 07653;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Itapetim', 07703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Itapissuma', 07752;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Itaquitinga', 07802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Jaboatão dos Guararapes', 07901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Jaqueira', 07950;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Jataúba', 08008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Jatobá', 08057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'João Alfredo', 08107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Joaquim Nabuco', 08206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Jucati', 08255;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Jupi', 08305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Jurema', 08404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Lagoa de Itaenga', 08503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Lagoa do Carro', 08453;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Lagoa do Ouro', 08602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Lagoa dos Gatos', 08701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Lagoa Grande', 08750;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Lajedo', 08800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Limoeiro', 08909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Macaparana', 09006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Machados', 09105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Manari', 09154;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Maraial', 09204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Mirandiba', 09303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Moreilândia', 14303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Moreno', 09402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Nazaré da Mata', 09501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Olinda', 09600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Orobó', 09709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Orocó', 09808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Ouricuri', 09907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Palmares', 10004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Palmeirina', 10103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Panelas', 10202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Paranatama', 10301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Parnamirim', 10400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Passira', 10509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Paudalho', 10608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Paulista', 10707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Pedra', 10806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Pesqueira', 10905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Petrolândia', 11002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Petrolina', 11101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Poção', 11200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Pombos', 11309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Primavera', 11408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Quipapá', 11507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Quixaba', 11533;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Recife', 11606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Riacho das Almas', 11705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Ribeirão', 11804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Rio Formoso', 11903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Sairé', 12000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Salgadinho', 12109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Salgueiro', 12208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Saloá', 12307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Sanharó', 12406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Santa Cruz', 12455;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Santa Cruz da Baixa Verde', 12471;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Santa Cruz do Capibaribe', 12505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Santa Filomena', 12554;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Santa Maria da Boa Vista', 12604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Santa Maria do Cambucá', 12703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Santa Terezinha', 12802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'São Benedito do Sul', 12901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'São Bento do Una', 13008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'São Caitano', 13107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'São João', 13206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'São Joaquim do Monte', 13305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'São José da Coroa Grande', 13404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'São José do Belmonte', 13503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'São José do Egito', 13602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'São Lourenço da Mata', 13701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'São Vicente Férrer', 13800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Serra Talhada', 13909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Serrita', 14006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Sertânia', 14105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Sirinhaém', 14204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Solidão', 14402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Surubim', 14501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Tabira', 14600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Tacaimbó', 14709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Tacaratu', 14808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Tamandaré', 14857;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Taquaritinga do Norte', 15003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Terezinha', 15102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Terra Nova', 15201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Timbaúba', 15300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Toritama', 15409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Tracunhaém', 15508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Trindade', 15607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Triunfo', 15706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Tupanatinga', 15805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Tuparetama', 15904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Venturosa', 16001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Verdejante', 16100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Vertente do Lério', 16183;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Vertentes', 16209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Vicência', 16308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Vitória de Santo Antão', 16407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 26), 'Xexéu', 16506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Água Branca', 00102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Anadia', 00201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Arapiraca', 00300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Atalaia', 00409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Barra de Santo Antônio', 00508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Barra de São Miguel', 00607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Batalha', 00706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Belém', 00805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Belo Monte', 00904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Boca da Mata', 01001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Branquinha', 01100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Cacimbinhas', 01209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Cajueiro', 01308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Campestre', 01357;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Campo Alegre', 01407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Campo Grande', 01506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Canapi', 01605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Capela', 01704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Carneiros', 01803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Chã Preta', 01902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Coité do Nóia', 02009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Colônia Leopoldina', 02108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Coqueiro Seco', 02207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Coruripe', 02306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Craíbas', 02355;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Delmiro Gouveia', 02405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Dois Riachos', 02504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Estrela de Alagoas', 02553;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Feira Grande', 02603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Feliz Deserto', 02702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Flexeiras', 02801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Girau do Ponciano', 02900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Ibateguara', 03007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Igaci', 03106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Igreja Nova', 03205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Inhapi', 03304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Jacaré dos Homens', 03403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Jacuípe', 03502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Japaratinga', 03601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Jaramataia', 03700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Jequiá da Praia', 03759;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Joaquim Gomes', 03809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Jundiá', 03908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Junqueiro', 04005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Lagoa da Canoa', 04104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Limoeiro de Anadia', 04203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Maceió', 04302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Major Isidoro', 04401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Mar Vermelho', 04906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Maragogi', 04500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Maravilha', 04609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Marechal Deodoro', 04708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Maribondo', 04807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Mata Grande', 05002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Matriz de Camaragibe', 05101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Messias', 05200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Minador do Negrão', 05309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Monteirópolis', 05408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Murici', 05507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Novo Lino', 05606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Olho d''Água das Flores', 05705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Olho d''Água do Casado', 05804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Olho d''Água Grande', 05903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Olivença', 06000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Ouro Branco', 06109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Palestina', 06208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Palmeira dos Índios', 06307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Pão de Açúcar', 06406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Pariconha', 06422;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Paripueira', 06448;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Passo de Camaragibe', 06505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Paulo Jacinto', 06604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Penedo', 06703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Piaçabuçu', 06802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Pilar', 06901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Pindoba', 07008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Piranhas', 07107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Poço das Trincheiras', 07206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Porto Calvo', 07305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Porto de Pedras', 07404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Porto Real do Colégio', 07503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Quebrangulo', 07602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Rio Largo', 07701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Roteiro', 07800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Santa Luzia do Norte', 07909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Santana do Ipanema', 08006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Santana do Mundaú', 08105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'São Brás', 08204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'São José da Laje', 08303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'São José da Tapera', 08402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'São Luís do Quitunde', 08501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'São Miguel dos Campos', 08600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'São Miguel dos Milagres', 08709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'São Sebastião', 08808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Satuba', 08907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Senador Rui Palmeira', 08956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Tanque d''Arca', 09004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Taquarana', 09103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Teotônio Vilela', 09152;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Traipu', 09202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'União dos Palmares', 09301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 27), 'Viçosa', 09400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Amparo do São Francisco', 00100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Aquidabã', 00209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Aracaju', 00308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Arauá', 00407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Areia Branca', 00506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Barra dos Coqueiros', 00605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Boquim', 00670;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Brejo Grande', 00704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Campo do Brito', 01009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Canhoba', 01108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Canindé de São Francisco', 01207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Capela', 01306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Carira', 01405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Carmópolis', 01504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Cedro de São João', 01603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Cristinápolis', 01702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Cumbe', 01900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Divina Pastora', 02007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Estância', 02106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Feira Nova', 02205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Frei Paulo', 02304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Gararu', 02403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'General Maynard', 02502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Graccho Cardoso', 02601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Ilha das Flores', 02700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Indiaroba', 02809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Itabaiana', 02908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Itabaianinha', 03005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Itabi', 03104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Itaporanga d''Ajuda', 03203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Japaratuba', 03302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Japoatã', 03401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Lagarto', 03500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Laranjeiras', 03609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Macambira', 03708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Malhada dos Bois', 03807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Malhador', 03906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Maruim', 04003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Moita Bonita', 04102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Monte Alegre de Sergipe', 04201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Muribeca', 04300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Neópolis', 04409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Nossa Senhora Aparecida', 04458;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Nossa Senhora da Glória', 04508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Nossa Senhora das Dores', 04607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Nossa Senhora de Lourdes', 04706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Nossa Senhora do Socorro', 04805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Pacatuba', 04904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Pedra Mole', 05000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Pedrinhas', 05109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Pinhão', 05208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Pirambu', 05307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Poço Redondo', 05406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Poço Verde', 05505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Porto da Folha', 05604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Propriá', 05703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Riachão do Dantas', 05802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Riachuelo', 05901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Ribeirópolis', 06008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Rosário do Catete', 06107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Salgado', 06206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Santa Luzia do Itanhy', 06305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Santa Rosa de Lima', 06503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Santana do São Francisco', 06404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Santo Amaro das Brotas', 06602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'São Cristóvão', 06701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'São Domingos', 06800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'São Francisco', 06909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'São Miguel do Aleixo', 07006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Simão Dias', 07105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Siriri', 07204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Telha', 07303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Tobias Barreto', 07402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Tomar do Geru', 07501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 28), 'Umbaúba', 07600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Abaíra', 00108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Abaré', 00207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Acajutiba', 00306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Adustina', 00355;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Água Fria', 00405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Aiquara', 00603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Alagoinhas', 00702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Alcobaça', 00801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Almadina', 00900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Amargosa', 01007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Amélia Rodrigues', 01106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'América Dourada', 01155;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Anagé', 01205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Andaraí', 01304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Andorinha', 01353;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Angical', 01403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Anguera', 01502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Antas', 01601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Antônio Cardoso', 01700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Antônio Gonçalves', 01809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Aporá', 01908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Apuarema', 01957;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Araçás', 02054;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Aracatu', 02005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Araci', 02104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Aramari', 02203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Arataca', 02252;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Aratuípe', 02302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Aurelino Leal', 02401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Baianópolis', 02500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Baixa Grande', 02609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Banzaê', 02658;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Barra', 02708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Barra da Estiva', 02807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Barra do Choça', 02906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Barra do Mendes', 03003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Barra do Rocha', 03102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Barreiras', 03201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Barro Alto', 03235;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Barro Preto', 03300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Barrocas', 03276;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Belmonte', 03409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Belo Campo', 03508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Biritinga', 03607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Boa Nova', 03706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Boa Vista do Tupim', 03805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Bom Jesus da Lapa', 03904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Bom Jesus da Serra', 03953;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Boninal', 04001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Bonito', 04050;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Boquira', 04100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Botuporã', 04209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Brejões', 04308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Brejolândia', 04407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Brotas de Macaúbas', 04506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Brumado', 04605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Buerarema', 04704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Buritirama', 04753;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Caatiba', 04803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cabaceiras do Paraguaçu', 04852;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cachoeira', 04902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Caculé', 05008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Caém', 05107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Caetanos', 05156;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Caetité', 05206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cafarnaum', 05305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cairu', 05404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Caldeirão Grande', 05503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Camacan', 05602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Camaçari', 05701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Camamu', 05800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Campo Alegre de Lourdes', 05909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Campo Formoso', 06006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Canápolis', 06105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Canarana', 06204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Canavieiras', 06303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Candeal', 06402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Candeias', 06501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Candiba', 06600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cândido Sales', 06709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cansanção', 06808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Canudos', 06824;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Capela do Alto Alegre', 06857;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Capim Grosso', 06873;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Caraíbas', 06899;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Caravelas', 06907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cardeal da Silva', 07004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Carinhanha', 07103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Casa Nova', 07202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Castro Alves', 07301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Catolândia', 07400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Catu', 07509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Caturama', 07558;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Central', 07608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Chorrochó', 07707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cícero Dantas', 07806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cipó', 07905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Coaraci', 08002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cocos', 08101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Conceição da Feira', 08200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Conceição do Almeida', 08309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Conceição do Coité', 08408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Conceição do Jacuípe', 08507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Conde', 08606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Condeúba', 08705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Contendas do Sincorá', 08804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Coração de Maria', 08903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cordeiros', 09000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Coribe', 09109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Coronel João Sá', 09208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Correntina', 09307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cotegipe', 09406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cravolândia', 09505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Crisópolis', 09604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cristópolis', 09703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Cruz das Almas', 09802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Curaçá', 09901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Dário Meira', 10008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Dias d''Ávila', 10057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Dom Basílio', 10107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Dom Macedo Costa', 10206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Elísio Medrado', 10305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Encruzilhada', 10404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Entre Rios', 10503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Érico Cardoso', 00504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Esplanada', 10602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Euclides da Cunha', 10701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Eunápolis', 10727;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Fátima', 10750;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Feira da Mata', 10776;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Feira de Santana', 10800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Filadélfia', 10859;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Firmino Alves', 10909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Floresta Azul', 11006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Formosa do Rio Preto', 11105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Gandu', 11204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Gavião', 11253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Gentio do Ouro', 11303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Glória', 11402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Gongogi', 11501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Governador Mangabeira', 11600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Guajeru', 11659;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Guanambi', 11709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Guaratinga', 11808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Heliópolis', 11857;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Iaçu', 11907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ibiassucê', 12004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ibicaraí', 12103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ibicoara', 12202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ibicuí', 12301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ibipeba', 12400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ibipitanga', 12509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ibiquera', 12608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ibirapitanga', 12707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ibirapuã', 12806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ibirataia', 12905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ibitiara', 13002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ibititá', 13101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ibotirama', 13200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ichu', 13309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Igaporã', 13408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Igrapiúna', 13457;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Iguaí', 13507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ilhéus', 13606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Inhambupe', 13705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ipecaetá', 13804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ipiaú', 13903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ipirá', 14000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ipupiara', 14109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Irajuba', 14208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Iramaia', 14307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Iraquara', 14406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Irará', 14505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Irecê', 14604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itabela', 14653;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itaberaba', 14703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itabuna', 14802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itacaré', 14901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itaeté', 15007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itagi', 15106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itagibá', 15205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itagimirim', 15304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itaguaçu da Bahia', 15353;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itaju do Colônia', 15403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itajuípe', 15502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itamaraju', 15601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itamari', 15700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itambé', 15809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itanagra', 15908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itanhém', 16005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itaparica', 16104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itapé', 16203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itapebi', 16302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itapetinga', 16401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itapicuru', 16500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itapitanga', 16609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itaquara', 16708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itarantim', 16807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itatim', 16856;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itiruçu', 16906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itiúba', 17003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Itororó', 17102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ituaçu', 17201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ituberá', 17300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Iuiu', 17334;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jaborandi', 17359;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jacaraci', 17409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jacobina', 17508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jaguaquara', 17607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jaguarari', 17706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jaguaripe', 17805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jandaíra', 17904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jequié', 18001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jeremoabo', 18100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jiquiriçá', 18209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jitaúna', 18308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'João Dourado', 18357;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Juazeiro', 18407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jucuruçu', 18456;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jussara', 18506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jussari', 18555;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Jussiape', 18605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Lafaiete Coutinho', 18704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Lagoa Real', 18753;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Laje', 18803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Lajedão', 18902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Lajedinho', 19009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Lajedo do Tabocal', 19058;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Lamarão', 19108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Lapão', 19157;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Lauro de Freitas', 19207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Lençóis', 19306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Licínio de Almeida', 19405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Livramento de Nossa Senhora', 19504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Luís Eduardo Magalhães', 19553;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Macajuba', 19603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Macarani', 19702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Macaúbas', 19801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Macururé', 19900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Madre de Deus', 19926;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Maetinga', 19959;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Maiquinique', 20007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Mairi', 20106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Malhada', 20205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Malhada de Pedras', 20304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Manoel Vitorino', 20403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Mansidão', 20452;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Maracás', 20502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Maragogipe', 20601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Maraú', 20700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Marcionílio Souza', 20809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Mascote', 20908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Mata de São João', 21005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Matina', 21054;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Medeiros Neto', 21104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Miguel Calmon', 21203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Milagres', 21302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Mirangaba', 21401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Mirante', 21450;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Monte Santo', 21500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Morpará', 21609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Morro do Chapéu', 21708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Mortugaba', 21807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Mucugê', 21906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Mucuri', 22003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Mulungu do Morro', 22052;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Mundo Novo', 22102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Muniz Ferreira', 22201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Muquém do São Francisco', 22250;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Muritiba', 22300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Mutuípe', 22409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Nazaré', 22508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Nilo Peçanha', 22607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Nordestina', 22656;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Nova Canaã', 22706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Nova Fátima', 22730;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Nova Ibiá', 22755;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Nova Itarana', 22805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Nova Redenção', 22854;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Nova Soure', 22904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Nova Viçosa', 23001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Novo Horizonte', 23035;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Novo Triunfo', 23050;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Olindina', 23100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Oliveira dos Brejinhos', 23209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ouriçangas', 23308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ourolândia', 23357;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Palmas de Monte Alto', 23407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Palmeiras', 23506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Paramirim', 23605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Paratinga', 23704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Paripiranga', 23803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Pau Brasil', 23902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Paulo Afonso', 24009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Pé de Serra', 24058;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Pedrão', 24108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Pedro Alexandre', 24207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Piatã', 24306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Pilão Arcado', 24405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Pindaí', 24504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Pindobaçu', 24603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Pintadas', 24652;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Piraí do Norte', 24678;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Piripá', 24702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Piritiba', 24801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Planaltino', 24900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Planalto', 25006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Poções', 25105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Pojuca', 25204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ponto Novo', 25253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Porto Seguro', 25303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Potiraguá', 25402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Prado', 25501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Presidente Dutra', 25600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Presidente Jânio Quadros', 25709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Presidente Tancredo Neves', 25758;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Queimadas', 25808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Quijingue', 25907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Quixabeira', 25931;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Rafael Jambeiro', 25956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Remanso', 26004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Retirolândia', 26103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Riachão das Neves', 26202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Riachão do Jacuípe', 26301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Riacho de Santana', 26400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ribeira do Amparo', 26509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ribeira do Pombal', 26608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ribeirão do Largo', 26657;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Rio de Contas', 26707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Rio do Antônio', 26806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Rio do Pires', 26905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Rio Real', 27002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Rodelas', 27101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ruy Barbosa', 27200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Salinas da Margarida', 27309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Salvador', 27408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santa Bárbara', 27507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santa Brígida', 27606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santa Cruz Cabrália', 27705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santa Cruz da Vitória', 27804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santa Inês', 27903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santa Luzia', 28059;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santa Maria da Vitória', 28109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santa Rita de Cássia', 28406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santa Terezinha', 28505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santaluz', 28000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santana', 28208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santanópolis', 28307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santo Amaro', 28604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santo Antônio de Jesus', 28703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Santo Estêvão', 28802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'São Desidério', 28901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'São Domingos', 28950;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'São Felipe', 29107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'São Félix', 29008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'São Félix do Coribe', 29057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'São Francisco do Conde', 29206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'São Gabriel', 29255;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'São Gonçalo dos Campos', 29305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'São José da Vitória', 29354;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'São José do Jacuípe', 29370;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'São Miguel das Matas', 29404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'São Sebastião do Passé', 29503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Sapeaçu', 29602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Sátiro Dias', 29701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Saubara', 29750;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Saúde', 29800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Seabra', 29909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Sebastião Laranjeiras', 30006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Senhor do Bonfim', 30105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Sento Sé', 30204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Serra do Ramalho', 30154;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Serra Dourada', 30303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Serra Preta', 30402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Serrinha', 30501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Serrolândia', 30600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Simões Filho', 30709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Sítio do Mato', 30758;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Sítio do Quinto', 30766;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Sobradinho', 30774;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Souto Soares', 30808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Tabocas do Brejo Velho', 30907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Tanhaçu', 31004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Tanque Novo', 31053;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Tanquinho', 31103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Taperoá', 31202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Tapiramutá', 31301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Teixeira de Freitas', 31350;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Teodoro Sampaio', 31400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Teofilândia', 31509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Teolândia', 31608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Terra Nova', 31707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Tremedal', 31806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Tucano', 31905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Uauá', 32002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ubaíra', 32101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ubaitaba', 32200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Ubatã', 32309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Uibaí', 32408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Umburanas', 32457;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Una', 32507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Urandi', 32606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Uruçuca', 32705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Utinga', 32804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Valença', 32903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Valente', 33000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Várzea da Roça', 33059;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Várzea do Poço', 33109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Várzea Nova', 33158;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Varzedo', 33174;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Vera Cruz', 33208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Vereda', 33257;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Vitória da Conquista', 33307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Wagner', 33406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Wanderley', 33455;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Wenceslau Guimarães', 33505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 29), 'Xique-Xique', 33604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Abadia dos Dourados', 00104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Abaeté', 00203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Abre Campo', 00302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Acaiaca', 00401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Açucena', 00500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Água Boa', 00609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Água Comprida', 00708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Aguanil', 00807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Águas Formosas', 00906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Águas Vermelhas', 01003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Aimorés', 01102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Aiuruoca', 01201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Alagoa', 01300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Albertina', 01409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Além Paraíba', 01508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Alfenas', 01607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Alfredo Vasconcelos', 01631;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Almenara', 01706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Alpercata', 01805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Alpinópolis', 01904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Alterosa', 02001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Alto Caparaó', 02050;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Alto Jequitibá', 53509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Alto Rio Doce', 02100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Alvarenga', 02209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Alvinópolis', 02308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Alvorada de Minas', 02407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Amparo do Serra', 02506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Andradas', 02605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Andrelândia', 02803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Angelândia', 02852;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Antônio Carlos', 02902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Antônio Dias', 03009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Antônio Prado de Minas', 03108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Araçaí', 03207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Aracitaba', 03306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Araçuaí', 03405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Araguari', 03504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Arantina', 03603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Araponga', 03702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Araporã', 03751;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Arapuá', 03801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Araújos', 03900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Araxá', 04007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Arceburgo', 04106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Arcos', 04205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Areado', 04304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Argirita', 04403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Aricanduva', 04452;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Arinos', 04502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Astolfo Dutra', 04601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ataléia', 04700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Augusto de Lima', 04809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Baependi', 04908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Baldim', 05004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bambuí', 05103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bandeira', 05202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bandeira do Sul', 05301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Barão de Cocais', 05400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Barão do Monte Alto', 05509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Barbacena', 05608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Barra Longa', 05707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Barroso', 05905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bela Vista de Minas', 06002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Belmiro Braga', 06101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Belo Horizonte', 06200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Belo Oriente', 06309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Belo Vale', 06408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Berilo', 06507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Berizal', 06655;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bertópolis', 06606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Betim', 06705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bias Fortes', 06804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bicas', 06903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Biquinhas', 07000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Boa Esperança', 07109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bocaina de Minas', 07208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bocaiúva', 07307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bom Despacho', 07406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bom Jardim de Minas', 07505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bom Jesus da Penha', 07604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bom Jesus do Amparo', 07703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bom Jesus do Galho', 07802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bom Repouso', 07901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bom Sucesso', 08008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bonfim', 08107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bonfinópolis de Minas', 08206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bonito de Minas', 08255;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Borda da Mata', 08305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Botelhos', 08404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Botumirim', 08503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Brás Pires', 08701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Brasilândia de Minas', 08552;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Brasília de Minas', 08602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Braúnas', 08800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Brazópolis', 08909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Brumadinho', 09006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bueno Brandão', 09105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Buenópolis', 09204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Bugre', 09253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Buritis', 09303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Buritizeiro', 09402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cabeceira Grande', 09451;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cabo Verde', 09501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cachoeira da Prata', 09600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cachoeira de Minas', 09709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cachoeira de Pajeú', 02704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cachoeira Dourada', 09808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Caetanópolis', 09907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Caeté', 10004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Caiana', 10103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cajuri', 10202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Caldas', 10301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Camacho', 10400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Camanducaia', 10509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cambuí', 10608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cambuquira', 10707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Campanário', 10806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Campanha', 10905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Campestre', 11002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Campina Verde', 11101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Campo Azul', 11150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Campo Belo', 11200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Campo do Meio', 11309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Campo Florido', 11408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Campos Altos', 11507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Campos Gerais', 11606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cana Verde', 11903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Canaã', 11705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Canápolis', 11804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Candeias', 12000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cantagalo', 12059;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Caparaó', 12109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Capela Nova', 12208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Capelinha', 12307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Capetinga', 12406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Capim Branco', 12505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Capinópolis', 12604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Capitão Andrade', 12653;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Capitão Enéas', 12703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Capitólio', 12802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Caputira', 12901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Caraí', 13008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Caranaíba', 13107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carandaí', 13206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carangola', 13305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Caratinga', 13404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carbonita', 13503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Careaçu', 13602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carlos Chagas', 13701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carmésia', 13800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carmo da Cachoeira', 13909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carmo da Mata', 14006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carmo de Minas', 14105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carmo do Cajuru', 14204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carmo do Paranaíba', 14303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carmo do Rio Claro', 14402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carmópolis de Minas', 14501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carneirinho', 14550;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carrancas', 14600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carvalhópolis', 14709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Carvalhos', 14808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Casa Grande', 14907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cascalho Rico', 15003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cássia', 15102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cataguases', 15300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Catas Altas', 15359;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Catas Altas da Noruega', 15409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Catuji', 15458;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Catuti', 15474;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Caxambu', 15508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cedro do Abaeté', 15607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Central de Minas', 15706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Centralina', 15805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Chácara', 15904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Chalé', 16001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Chapada do Norte', 16100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Chapada Gaúcha', 16159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Chiador', 16209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cipotânea', 16308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Claraval', 16407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Claro dos Poções', 16506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cláudio', 16605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Coimbra', 16704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Coluna', 16803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Comendador Gomes', 16902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Comercinho', 17009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Conceição da Aparecida', 17108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Conceição da Barra de Minas', 15201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Conceição das Alagoas', 17306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Conceição das Pedras', 17207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Conceição de Ipanema', 17405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Conceição do Mato Dentro', 17504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Conceição do Pará', 17603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Conceição do Rio Verde', 17702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Conceição dos Ouros', 17801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cônego Marinho', 17836;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Confins', 17876;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Congonhal', 17900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Congonhas', 18007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Congonhas do Norte', 18106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Conquista', 18205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Conselheiro Lafaiete', 18304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Conselheiro Pena', 18403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Consolação', 18502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Contagem', 18601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Coqueiral', 18700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Coração de Jesus', 18809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cordisburgo', 18908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cordislândia', 19005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Corinto', 19104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Coroaci', 19203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Coromandel', 19302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Coronel Fabriciano', 19401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Coronel Murta', 19500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Coronel Pacheco', 19609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Coronel Xavier Chaves', 19708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Córrego Danta', 19807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Córrego do Bom Jesus', 19906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Córrego Fundo', 19955;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Córrego Novo', 20003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Couto de Magalhães de Minas', 20102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Crisólita', 20151;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cristais', 20201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cristália', 20300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cristiano Otoni', 20409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cristina', 20508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Crucilândia', 20607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cruzeiro da Fortaleza', 20706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cruzília', 20805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Cuparaque', 20839;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Curral de Dentro', 20870;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Curvelo', 20904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Datas', 21001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Delfim Moreira', 21100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Delfinópolis', 21209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Delta', 21258;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Descoberto', 21308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Desterro de Entre Rios', 21407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Desterro do Melo', 21506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Diamantina', 21605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Diogo de Vasconcelos', 21704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Dionísio', 21803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Divinésia', 21902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Divino', 22009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Divino das Laranjeiras', 22108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Divinolândia de Minas', 22207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Divinópolis', 22306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Divisa Alegre', 22355;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Divisa Nova', 22405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Divisópolis', 22454;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Dom Bosco', 22470;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Dom Cavati', 22504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Dom Joaquim', 22603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Dom Silvério', 22702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Dom Viçoso', 22801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Dona Euzébia', 22900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Dores de Campos', 23007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Dores de Guanhães', 23106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Dores do Indaiá', 23205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Dores do Turvo', 23304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Doresópolis', 23403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Douradoquara', 23502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Durandé', 23528;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Elói Mendes', 23601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Engenheiro Caldas', 23700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Engenheiro Navarro', 23809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Entre Folhas', 23858;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Entre Rios de Minas', 23908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ervália', 24005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Esmeraldas', 24104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Espera Feliz', 24203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Espinosa', 24302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Espírito Santo do Dourado', 24401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Estiva', 24500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Estrela Dalva', 24609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Estrela do Indaiá', 24708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Estrela do Sul', 24807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Eugenópolis', 24906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ewbank da Câmara', 25002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Extrema', 25101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Fama', 25200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Faria Lemos', 25309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Felício dos Santos', 25408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Felisburgo', 25606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Felixlândia', 25705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Fernandes Tourinho', 25804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ferros', 25903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Fervedouro', 25952;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Florestal', 26000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Formiga', 26109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Formoso', 26208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Fortaleza de Minas', 26307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Fortuna de Minas', 26406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Francisco Badaró', 26505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Francisco Dumont', 26604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Francisco Sá', 26703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Franciscópolis', 26752;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Frei Gaspar', 26802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Frei Inocêncio', 26901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Frei Lagonegro', 26950;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Fronteira', 27008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Fronteira dos Vales', 27057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Fruta de Leite', 27073;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Frutal', 27107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Funilândia', 27206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Galiléia', 27305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Gameleiras', 27339;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Glaucilândia', 27354;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Goiabeira', 27370;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Goianá', 27388;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Gonçalves', 27404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Gonzaga', 27503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Gouveia', 27602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Governador Valadares', 27701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Grão Mogol', 27800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Grupiara', 27909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Guanhães', 28006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Guapé', 28105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Guaraciaba', 28204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Guaraciama', 28253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Guaranésia', 28303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Guarani', 28402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Guarará', 28501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Guarda-Mor', 28600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Guaxupé', 28709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Guidoval', 28808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Guimarânia', 28907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Guiricema', 29004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Gurinhatã', 29103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Heliodora', 29202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Iapu', 29301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ibertioga', 29400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ibiá', 29509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ibiaí', 29608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ibiracatu', 29657;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ibiraci', 29707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ibirité', 29806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ibitiúra de Minas', 29905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ibituruna', 30002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Icaraí de Minas', 30051;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Igarapé', 30101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Igaratinga', 30200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Iguatama', 30309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ijaci', 30408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ilicínea', 30507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Imbé de Minas', 30556;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Inconfidentes', 30606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Indaiabira', 30655;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Indianópolis', 30705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ingaí', 30804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Inhapim', 30903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Inhaúma', 31000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Inimutaba', 31109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ipaba', 31158;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ipanema', 31208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ipatinga', 31307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ipiaçu', 31406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ipuiúna', 31505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Iraí de Minas', 31604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itabira', 31703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itabirinha', 31802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itabirito', 31901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itacambira', 32008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itacarambi', 32107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itaguara', 32206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itaipé', 32305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itajubá', 32404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itamarandiba', 32503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itamarati de Minas', 32602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itambacuri', 32701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itambé do Mato Dentro', 32800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itamogi', 32909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itamonte', 33006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itanhandu', 33105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itanhomi', 33204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itaobim', 33303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itapagipe', 33402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itapecerica', 33501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itapeva', 33600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itatiaiuçu', 33709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itaú de Minas', 33758;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itaúna', 33808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itaverava', 33907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itinga', 34004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itueta', 34103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ituiutaba', 34202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itumirim', 34301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Iturama', 34400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Itutinga', 34509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jaboticatubas', 34608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jacinto', 34707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jacuí', 34806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jacutinga', 34905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jaguaraçu', 35001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jaíba', 35050;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jampruca', 35076;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Janaúba', 35100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Januária', 35209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Japaraíba', 35308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Japonvar', 35357;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jeceaba', 35407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jenipapo de Minas', 35456;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jequeri', 35506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jequitaí', 35605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jequitibá', 35704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jequitinhonha', 35803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jesuânia', 35902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Joaíma', 36009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Joanésia', 36108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'João Monlevade', 36207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'João Pinheiro', 36306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Joaquim Felício', 36405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Jordânia', 36504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'José Gonçalves de Minas', 36520;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'José Raydan', 36553;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Josenópolis', 36579;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Juatuba', 36652;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Juiz de Fora', 36702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Juramento', 36801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Juruaia', 36900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Juvenília', 36959;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ladainha', 37007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lagamar', 37106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lagoa da Prata', 37205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lagoa dos Patos', 37304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lagoa Dourada', 37403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lagoa Formosa', 37502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lagoa Grande', 37536;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lagoa Santa', 37601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lajinha', 37700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lambari', 37809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lamim', 37908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Laranjal', 38005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lassance', 38104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lavras', 38203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Leandro Ferreira', 38302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Leme do Prado', 38351;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Leopoldina', 38401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Liberdade', 38500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lima Duarte', 38609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Limeira do Oeste', 38625;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Lontra', 38658;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Luisburgo', 38674;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Luislândia', 38682;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Luminárias', 38708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Luz', 38807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Machacalis', 38906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Machado', 39003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Madre de Deus de Minas', 39102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Malacacheta', 39201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mamonas', 39250;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Manga', 39300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Manhuaçu', 39409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Manhumirim', 39508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mantena', 39607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mar de Espanha', 39805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Maravilhas', 39706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Maria da Fé', 39904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mariana', 40001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Marilac', 40100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mário Campos', 40159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Maripá de Minas', 40209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Marliéria', 40308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Marmelópolis', 40407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Martinho Campos', 40506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Martins Soares', 40530;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mata Verde', 40555;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Materlândia', 40605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mateus Leme', 40704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mathias Lobato', 71501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Matias Barbosa', 40803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Matias Cardoso', 40852;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Matipó', 40902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mato Verde', 41009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Matozinhos', 41108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Matutina', 41207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Medeiros', 41306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Medina', 41405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mendes Pimentel', 41504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mercês', 41603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mesquita', 41702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Minas Novas', 41801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Minduri', 41900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mirabela', 42007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Miradouro', 42106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Miraí', 42205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Miravânia', 42254;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Moeda', 42304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Moema', 42403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Monjolos', 42502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Monsenhor Paulo', 42601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Montalvânia', 42700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Monte Alegre de Minas', 42809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Monte Azul', 42908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Monte Belo', 43005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Monte Carmelo', 43104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Monte Formoso', 43153;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Monte Santo de Minas', 43203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Monte Sião', 43401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Montes Claros', 43302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Montezuma', 43450;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Morada Nova de Minas', 43500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Morro da Garça', 43609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Morro do Pilar', 43708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Munhoz', 43807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Muriaé', 43906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Mutum', 44003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Muzambinho', 44102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Nacip Raydan', 44201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Nanuque', 44300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Naque', 44359;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Natalândia', 44375;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Natércia', 44409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Nazareno', 44508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Nepomuceno', 44607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ninheira', 44656;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Nova Belém', 44672;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Nova Era', 44706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Nova Lima', 44805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Nova Módica', 44904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Nova Ponte', 45000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Nova Porteirinha', 45059;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Nova Resende', 45109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Nova Serrana', 45208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Nova União', 36603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Novo Cruzeiro', 45307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Novo Oriente de Minas', 45356;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Novorizonte', 45372;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Olaria', 45406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Olhos-d''Água', 45455;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Olímpio Noronha', 45505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Oliveira', 45604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Oliveira Fortes', 45703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Onça de Pitangui', 45802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Oratórios', 45851;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Orizânia', 45877;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ouro Branco', 45901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ouro Fino', 46008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ouro Preto', 46107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ouro Verde de Minas', 46206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Padre Carvalho', 46255;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Padre Paraíso', 46305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pai Pedro', 46552;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Paineiras', 46404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pains', 46503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Paiva', 46602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Palma', 46701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Palmópolis', 46750;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Papagaios', 46909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pará de Minas', 47105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Paracatu', 47006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Paraguaçu', 47204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Paraisópolis', 47303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Paraopeba', 47402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Passa Quatro', 47600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Passa Tempo', 47709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Passa Vinte', 47808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Passabém', 47501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Passos', 47907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Patis', 47956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Patos de Minas', 48004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Patrocínio', 48103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Patrocínio do Muriaé', 48202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Paula Cândido', 48301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Paulistas', 48400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pavão', 48509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Peçanha', 48608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pedra Azul', 48707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pedra Bonita', 48756;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pedra do Anta', 48806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pedra do Indaiá', 48905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pedra Dourada', 49002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pedralva', 49101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pedras de Maria da Cruz', 49150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pedrinópolis', 49200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pedro Leopoldo', 49309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pedro Teixeira', 49408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pequeri', 49507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pequi', 49606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Perdigão', 49705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Perdizes', 49804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Perdões', 49903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Periquito', 49952;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pescador', 50000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Piau', 50109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Piedade de Caratinga', 50158;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Piedade de Ponte Nova', 50208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Piedade do Rio Grande', 50307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Piedade dos Gerais', 50406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pimenta', 50505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pingo-d''Água', 50539;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pintópolis', 50570;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Piracema', 50604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pirajuba', 50703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Piranga', 50802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Piranguçu', 50901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Piranguinho', 51008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pirapetinga', 51107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pirapora', 51206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Piraúba', 51305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pitangui', 51404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Piumhi', 51503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Planura', 51602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Poço Fundo', 51701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Poços de Caldas', 51800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pocrane', 51909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pompéu', 52006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ponte Nova', 52105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ponto Chique', 52131;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ponto dos Volantes', 52170;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Porteirinha', 52204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Porto Firme', 52303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Poté', 52402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pouso Alegre', 52501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pouso Alto', 52600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Prados', 52709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Prata', 52808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pratápolis', 52907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Pratinha', 53004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Presidente Bernardes', 53103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Presidente Juscelino', 53202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Presidente Kubitschek', 53301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Presidente Olegário', 53400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Prudente de Morais', 53608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Quartel Geral', 53707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Queluzito', 53806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Raposos', 53905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Raul Soares', 54002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Recreio', 54101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Reduto', 54150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Resende Costa', 54200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Resplendor', 54309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ressaquinha', 54408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Riachinho', 54457;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Riacho dos Machados', 54507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ribeirão das Neves', 54606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ribeirão Vermelho', 54705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rio Acima', 54804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rio Casca', 54903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rio do Prado', 55108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rio Doce', 55009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rio Espera', 55207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rio Manso', 55306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rio Novo', 55405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rio Paranaíba', 55504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rio Pardo de Minas', 55603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rio Piracicaba', 55702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rio Pomba', 55801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rio Preto', 55900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rio Vermelho', 56007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ritápolis', 56106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rochedo de Minas', 56205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rodeiro', 56304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Romaria', 56403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rosário da Limeira', 56452;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rubelita', 56502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Rubim', 56601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Sabará', 56700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Sabinópolis', 56809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Sacramento', 56908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Salinas', 57005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Salto da Divisa', 57104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Bárbara', 57203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Bárbara do Leste', 57252;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Bárbara do Monte Verde', 57278;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Bárbara do Tugúrio', 57302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Cruz de Minas', 57336;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Cruz de Salinas', 57377;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Cruz do Escalvado', 57401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Efigênia de Minas', 57500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Fé de Minas', 57609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Helena de Minas', 57658;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Juliana', 57708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Luzia', 57807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Margarida', 57906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Maria de Itabira', 58003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Maria do Salto', 58102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Maria do Suaçuí', 58201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Rita de Caldas', 59209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Rita de Ibitipoca', 59407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Rita de Jacutinga', 59308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Rita de Minas', 59357;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Rita do Itueto', 59506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Rita do Sapucaí', 59605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Rosa da Serra', 59704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santa Vitória', 59803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santana da Vargem', 58300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santana de Cataguases', 58409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santana de Pirapama', 58508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santana do Deserto', 58607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santana do Garambéu', 58706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santana do Jacaré', 58805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santana do Manhuaçu', 58904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santana do Paraíso', 58953;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santana do Riacho', 59001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santana dos Montes', 59100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santo Antônio do Amparo', 59902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santo Antônio do Aventureiro', 60009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santo Antônio do Grama', 60108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santo Antônio do Itambé', 60207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santo Antônio do Jacinto', 60306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santo Antônio do Monte', 60405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santo Antônio do Retiro', 60454;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santo Antônio do Rio Abaixo', 60504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santo Hipólito', 60603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Santos Dumont', 60702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Bento Abade', 60801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Brás do Suaçuí', 60900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Domingos das Dores', 60959;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Domingos do Prata', 61007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Félix de Minas', 61056;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Francisco', 61106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Francisco de Paula', 61205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Francisco de Sales', 61304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Francisco do Glória', 61403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Geraldo', 61502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Geraldo da Piedade', 61601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Geraldo do Baixio', 61650;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Gonçalo do Abaeté', 61700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Gonçalo do Pará', 61809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Gonçalo do Rio Abaixo', 61908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Gonçalo do Rio Preto', 25507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Gonçalo do Sapucaí', 62005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Gotardo', 62104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São João Batista do Glória', 62203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São João da Lagoa', 62252;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São João da Mata', 62302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São João da Ponte', 62401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São João das Missões', 62450;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São João del Rei', 62500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São João do Manhuaçu', 62559;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São João do Manteninha', 62575;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São João do Oriente', 62609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São João do Pacuí', 62658;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São João do Paraíso', 62708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São João Evangelista', 62807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São João Nepomuceno', 62906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Joaquim de Bicas', 62922;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São José da Barra', 62948;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São José da Lapa', 62955;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São José da Safira', 63003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São José da Varginha', 63102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São José do Alegre', 63201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São José do Divino', 63300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São José do Goiabal', 63409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São José do Jacuri', 63508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São José do Mantimento', 63607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Lourenço', 63706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Miguel do Anta', 63805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Pedro da União', 63904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Pedro do Suaçuí', 64100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Pedro dos Ferros', 64001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Romão', 64209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Roque de Minas', 64308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Sebastião da Bela Vista', 64407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Sebastião da Vargem Alegre', 64431;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Sebastião do Anta', 64472;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Sebastião do Maranhão', 64506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Sebastião do Oeste', 64605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Sebastião do Paraíso', 64704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Sebastião do Rio Preto', 64803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Sebastião do Rio Verde', 64902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Tiago', 65008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Tomás de Aquino', 65107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Tomé das Letras', 65206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'São Vicente de Minas', 65305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Sapucaí-Mirim', 65404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Sardoá', 65503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Sarzedo', 65537;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Sem-Peixe', 65560;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Senador Amaral', 65578;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Senador Cortes', 65602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Senador Firmino', 65701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Senador José Bento', 65800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Senador Modestino Gonçalves', 65909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Senhora de Oliveira', 66006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Senhora do Porto', 66105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Senhora dos Remédios', 66204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Sericita', 66303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Seritinga', 66402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Serra Azul de Minas', 66501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Serra da Saudade', 66600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Serra do Salitre', 66808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Serra dos Aimorés', 66709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Serrania', 66907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Serranópolis de Minas', 66956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Serranos', 67004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Serro', 67103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Sete Lagoas', 67202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Setubinha', 65552;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Silveirânia', 67301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Silvianópolis', 67400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Simão Pereira', 67509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Simonésia', 67608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Sobrália', 67707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Soledade de Minas', 67806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Tabuleiro', 67905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Taiobeiras', 68002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Taparuba', 68051;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Tapira', 68101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Tapiraí', 68200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Taquaraçu de Minas', 68309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Tarumirim', 68408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Teixeiras', 68507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Teófilo Otoni', 68606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Timóteo', 68705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Tiradentes', 68804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Tiros', 68903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Tocantins', 69000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Tocos do Moji', 69059;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Toledo', 69109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Tombos', 69208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Três Corações', 69307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Três Marias', 69356;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Três Pontas', 69406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Tumiritinga', 69505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Tupaciguara', 69604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Turmalina', 69703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Turvolândia', 69802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ubá', 69901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ubaí', 70008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Ubaporanga', 70057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Uberaba', 70107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Uberlândia', 70206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Umburatiba', 70305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Unaí', 70404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'União de Minas', 70438;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Uruana de Minas', 70479;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Urucânia', 70503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Urucuia', 70529;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Vargem Alegre', 70578;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Vargem Bonita', 70602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Vargem Grande do Rio Pardo', 70651;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Varginha', 70701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Varjão de Minas', 70750;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Várzea da Palma', 70800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Varzelândia', 70909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Vazante', 71006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Verdelândia', 71030;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Veredinha', 71071;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Veríssimo', 71105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Vermelho Novo', 71154;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Vespasiano', 71204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Viçosa', 71303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Vieiras', 71402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Virgem da Lapa', 71600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Virgínia', 71709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Virginópolis', 71808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Virgolândia', 71907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Visconde do Rio Branco', 72004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Volta Grande', 72103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 31), 'Wenceslau Braz', 72202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Afonso Cláudio', 00102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Água Doce do Norte', 00169;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Águia Branca', 00136;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Alegre', 00201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Alfredo Chaves', 00300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Alto Rio Novo', 00359;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Anchieta', 00409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Apiacá', 00508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Aracruz', 00607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Atílio Vivácqua', 00706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Baixo Guandu', 00805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Barra de São Francisco', 00904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Boa Esperança', 01001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Bom Jesus do Norte', 01100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Brejetuba', 01159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Cachoeiro de Itapemirim', 01209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Cariacica', 01308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Castelo', 01407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Colatina', 01506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Conceição da Barra', 01605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Conceição do Castelo', 01704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Divino de São Lourenço', 01803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Domingos Martins', 01902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Dores do Rio Preto', 02009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Ecoporanga', 02108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Fundão', 02207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Governador Lindenberg', 02256;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Guaçuí', 02306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Guarapari', 02405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Ibatiba', 02454;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Ibiraçu', 02504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Ibitirama', 02553;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Iconha', 02603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Irupi', 02652;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Itaguaçu', 02702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Itapemirim', 02801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Itarana', 02900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Iúna', 03007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Jaguaré', 03056;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Jerônimo Monteiro', 03106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'João Neiva', 03130;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Laranja da Terra', 03163;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Linhares', 03205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Mantenópolis', 03304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Marataízes', 03320;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Marechal Floriano', 03346;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Marilândia', 03353;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Mimoso do Sul', 03403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Montanha', 03502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Mucurici', 03601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Muniz Freire', 03700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Muqui', 03809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Nova Venécia', 03908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Pancas', 04005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Pedro Canário', 04054;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Pinheiros', 04104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Piúma', 04203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Ponto Belo', 04252;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Presidente Kennedy', 04302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Rio Bananal', 04351;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Rio Novo do Sul', 04401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Santa Leopoldina', 04500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Santa Maria de Jetibá', 04559;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Santa Teresa', 04609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'São Domingos do Norte', 04658;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'São Gabriel da Palha', 04708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'São José do Calçado', 04807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'São Mateus', 04906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'São Roque do Canaã', 04955;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Serra', 05002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Sooretama', 05010;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Vargem Alta', 05036;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Venda Nova do Imigrante', 05069;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Viana', 05101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Vila Pavão', 05150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Vila Valério', 05176;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Vila Velha', 05200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 32), 'Vitória', 05309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Angra dos Reis', 00100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Aperibé', 00159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Araruama', 00209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Areal', 00225;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Armação dos Búzios', 00233;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Arraial do Cabo', 00258;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Barra do Piraí', 00308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Barra Mansa', 00407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Belford Roxo', 00456;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Bom Jardim', 00506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Bom Jesus do Itabapoana', 00605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Cabo Frio', 00704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Cachoeiras de Macacu', 00803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Cambuci', 00902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Campos dos Goytacazes', 01009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Cantagalo', 01108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Carapebus', 00936;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Cardoso Moreira', 01157;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Carmo', 01207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Casimiro de Abreu', 01306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Comendador Levy Gasparian', 00951;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Conceição de Macabu', 01405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Cordeiro', 01504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Duas Barras', 01603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Duque de Caxias', 01702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Engenheiro Paulo de Frontin', 01801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Guapimirim', 01850;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Iguaba Grande', 01876;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Itaboraí', 01900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Itaguaí', 02007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Italva', 02056;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Itaocara', 02106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Itaperuna', 02205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Itatiaia', 02254;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Japeri', 02270;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Laje do Muriaé', 02304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Macaé', 02403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Macuco', 02452;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Magé', 02502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Mangaratiba', 02601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Maricá', 02700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Mendes', 02809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Mesquita', 02858;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Miguel Pereira', 02908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Miracema', 03005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Natividade', 03104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Nilópolis', 03203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Niterói', 03302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Nova Friburgo', 03401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Nova Iguaçu', 03500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Paracambi', 03609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Paraíba do Sul', 03708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Paraty', 03807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Paty do Alferes', 03856;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Petrópolis', 03906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Pinheiral', 03955;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Piraí', 04003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Porciúncula', 04102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Porto Real', 04110;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Quatis', 04128;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Queimados', 04144;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Quissamã', 04151;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Resende', 04201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Rio Bonito', 04300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Rio Claro', 04409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Rio das Flores', 04508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Rio das Ostras', 04524;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Rio de Janeiro', 04557;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Santa Maria Madalena', 04607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Santo Antônio de Pádua', 04706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'São Fidélis', 04805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'São Francisco de Itabapoana', 04755;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'São Gonçalo', 04904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'São João da Barra', 05000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'São João de Meriti', 05109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'São José de Ubá', 05133;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'São José do Vale do Rio Preto', 05158;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'São Pedro da Aldeia', 05208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'São Sebastião do Alto', 05307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Sapucaia', 05406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Saquarema', 05505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Seropédica', 05554;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Silva Jardim', 05604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Sumidouro', 05703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Tanguá', 05752;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Teresópolis', 05802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Trajano de Moraes', 05901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Três Rios', 06008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Valença', 06107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Varre-Sai', 06156;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Vassouras', 06206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 33), 'Volta Redonda', 06305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Adamantina', 00105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Adolfo', 00204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Aguaí', 00303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Águas da Prata', 00402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Águas de Lindóia', 00501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Águas de Santa Bárbara', 00550;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Águas de São Pedro', 00600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Agudos', 00709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Alambari', 00758;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Alfredo Marcondes', 00808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Altair', 00907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Altinópolis', 01004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Alto Alegre', 01103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Alumínio', 01152;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Álvares Florence', 01202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Álvares Machado', 01301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Álvaro de Carvalho', 01400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Alvinlândia', 01509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Americana', 01608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Américo Brasiliense', 01707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Américo de Campos', 01806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Amparo', 01905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Analândia', 02002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Andradina', 02101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Angatuba', 02200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Anhembi', 02309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Anhumas', 02408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Aparecida', 02507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Aparecida d''Oeste', 02606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Apiaí', 02705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Araçariguama', 02754;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Araçatuba', 02804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Araçoiaba da Serra', 02903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Aramina', 03000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Arandu', 03109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Arapeí', 03158;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Araraquara', 03208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Araras', 03307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Arco-Íris', 03356;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Arealva', 03406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Areias', 03505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Areiópolis', 03604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ariranha', 03703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Artur Nogueira', 03802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Arujá', 03901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Aspásia', 03950;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Assis', 04008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Atibaia', 04107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Auriflama', 04206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Avaí', 04305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Avanhandava', 04404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Avaré', 04503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bady Bassitt', 04602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Balbinos', 04701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bálsamo', 04800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bananal', 04909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Barão de Antonina', 05005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Barbosa', 05104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bariri', 05203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Barra Bonita', 05302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Barra do Chapéu', 05351;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Barra do Turvo', 05401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Barretos', 05500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Barrinha', 05609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Barueri', 05708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bastos', 05807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Batatais', 05906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bauru', 06003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bebedouro', 06102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bento de Abreu', 06201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bernardino de Campos', 06300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bertioga', 06359;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bilac', 06409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Birigui', 06508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Biritiba Mirim', 06607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Boa Esperança do Sul', 06706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bocaina', 06805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bofete', 06904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Boituva', 07001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bom Jesus dos Perdões', 07100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bom Sucesso de Itararé', 07159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Borá', 07209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Boracéia', 07308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Borborema', 07407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Borebi', 07456;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Botucatu', 07506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Bragança Paulista', 07605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Braúna', 07704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Brejo Alegre', 07753;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Brodowski', 07803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Brotas', 07902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Buri', 08009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Buritama', 08108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Buritizal', 08207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cabrália Paulista', 08306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cabreúva', 08405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Caçapava', 08504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cachoeira Paulista', 08603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Caconde', 08702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cafelândia', 08801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Caiabu', 08900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Caieiras', 09007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Caiuá', 09106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cajamar', 09205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cajati', 09254;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cajobi', 09304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cajuru', 09403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Campina do Monte Alegre', 09452;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Campinas', 09502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Campo Limpo Paulista', 09601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Campos do Jordão', 09700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Campos Novos Paulista', 09809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cananéia', 09908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Canas', 09957;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cândido Mota', 10005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cândido Rodrigues', 10104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Canitar', 10153;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Capão Bonito', 10203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Capela do Alto', 10302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Capivari', 10401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Caraguatatuba', 10500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Carapicuíba', 10609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cardoso', 10708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Casa Branca', 10807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cássia dos Coqueiros', 10906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Castilho', 11003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Catanduva', 11102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Catiguá', 11201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cedral', 11300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cerqueira César', 11409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cerquilho', 11508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cesário Lange', 11607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Charqueada', 11706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Chavantes', 57204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Clementina', 11904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Colina', 12001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Colômbia', 12100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Conchal', 12209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Conchas', 12308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cordeirópolis', 12407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Coroados', 12506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Coronel Macedo', 12605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Corumbataí', 12704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cosmópolis', 12803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cosmorama', 12902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cotia', 13009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cravinhos', 13108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cristais Paulista', 13207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cruzália', 13306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cruzeiro', 13405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cubatão', 13504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Cunha', 13603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Descalvado', 13702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Diadema', 13801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Dirce Reis', 13850;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Divinolândia', 13900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Dobrada', 14007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Dois Córregos', 14106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Dolcinópolis', 14205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Dourado', 14304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Dracena', 14403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Duartina', 14502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Dumont', 14601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Echaporã', 14700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Eldorado', 14809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Elias Fausto', 14908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Elisiário', 14924;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Embaúba', 14957;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Embu das Artes', 15004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Embu-Guaçu', 15103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Emilianópolis', 15129;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Engenheiro Coelho', 15152;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Espírito Santo do Pinhal', 15186;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Espírito Santo do Turvo', 15194;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Estiva Gerbi', 57303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Estrela do Norte', 15301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Estrela d''Oeste', 15202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Euclides da Cunha Paulista', 15350;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Fartura', 15400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Fernando Prestes', 15608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Fernandópolis', 15509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Fernão', 15657;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ferraz de Vasconcelos', 15707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Flora Rica', 15806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Floreal', 15905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Flórida Paulista', 16002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Florínea', 16101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Franca', 16200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Francisco Morato', 16309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Franco da Rocha', 16408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Gabriel Monteiro', 16507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Gália', 16606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Garça', 16705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Gastão Vidigal', 16804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Gavião Peixoto', 16853;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'General Salgado', 16903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Getulina', 17000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Glicério', 17109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guaiçara', 17208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guaimbê', 17307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guaíra', 17406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guapiaçu', 17505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guapiara', 17604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guará', 17703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guaraçaí', 17802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guaraci', 17901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guarani d''Oeste', 18008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guarantã', 18107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guararapes', 18206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guararema', 18305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guaratinguetá', 18404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guareí', 18503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guariba', 18602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guarujá', 18701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guarulhos', 18800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guatapará', 18859;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Guzolândia', 18909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Herculândia', 19006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Holambra', 19055;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Hortolândia', 19071;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Iacanga', 19105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Iacri', 19204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Iaras', 19253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ibaté', 19303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ibirá', 19402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ibirarema', 19501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ibitinga', 19600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ibiúna', 19709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Icém', 19808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Iepê', 19907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Igaraçu do Tietê', 20004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Igarapava', 20103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Igaratá', 20202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Iguape', 20301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ilha Comprida', 20426;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ilha Solteira', 20442;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ilhabela', 20400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Indaiatuba', 20509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Indiana', 20608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Indiaporã', 20707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Inúbia Paulista', 20806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ipaussu', 20905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Iperó', 21002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ipeúna', 21101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ipiguá', 21150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Iporanga', 21200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ipuã', 21309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Iracemápolis', 21408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Irapuã', 21507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Irapuru', 21606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itaberá', 21705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itaí', 21804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itajobi', 21903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itaju', 22000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itanhaém', 22109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itaoca', 22158;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itapecerica da Serra', 22208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itapetininga', 22307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itapeva', 22406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itapevi', 22505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itapira', 22604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itapirapuã Paulista', 22653;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itápolis', 22703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itaporanga', 22802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itapuí', 22901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itapura', 23008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itaquaquecetuba', 23107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itararé', 23206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itariri', 23305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itatiba', 23404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itatinga', 23503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itirapina', 23602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itirapuã', 23701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itobi', 23800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itu', 23909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Itupeva', 24006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ituverava', 24105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jaborandi', 24204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jaboticabal', 24303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jacareí', 24402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jaci', 24501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jacupiranga', 24600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jaguariúna', 24709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jales', 24808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jambeiro', 24907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jandira', 25003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jardinópolis', 25102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jarinu', 25201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jaú', 25300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jeriquara', 25409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Joanópolis', 25508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'João Ramalho', 25607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'José Bonifácio', 25706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Júlio Mesquita', 25805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jumirim', 25854;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Jundiaí', 25904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Junqueirópolis', 26001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Juquiá', 26100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Juquitiba', 26209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Lagoinha', 26308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Laranjal Paulista', 26407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Lavínia', 26506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Lavrinhas', 26605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Leme', 26704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Lençóis Paulista', 26803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Limeira', 26902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Lindóia', 27009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Lins', 27108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Lorena', 27207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Lourdes', 27256;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Louveira', 27306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Lucélia', 27405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Lucianópolis', 27504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Luís Antônio', 27603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Luiziânia', 27702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Lupércio', 27801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Lutécia', 27900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Macatuba', 28007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Macaubal', 28106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Macedônia', 28205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Magda', 28304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mairinque', 28403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mairiporã', 28502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Manduri', 28601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Marabá Paulista', 28700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Maracaí', 28809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Marapoama', 28858;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mariápolis', 28908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Marília', 29005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Marinópolis', 29104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Martinópolis', 29203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Matão', 29302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mauá', 29401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mendonça', 29500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Meridiano', 29609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mesópolis', 29658;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Miguelópolis', 29708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mineiros do Tietê', 29807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mira Estrela', 30003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Miracatu', 29906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mirandópolis', 30102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mirante do Paranapanema', 30201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mirassol', 30300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mirassolândia', 30409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mococa', 30508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mogi das Cruzes', 30607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mogi Guaçu', 30706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mogi Mirim', 30805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mombuca', 30904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Monções', 31001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Mongaguá', 31100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Monte Alegre do Sul', 31209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Monte Alto', 31308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Monte Aprazível', 31407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Monte Azul Paulista', 31506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Monte Castelo', 31605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Monte Mor', 31803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Monteiro Lobato', 31704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Morro Agudo', 31902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Morungaba', 32009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Motuca', 32058;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Murutinga do Sul', 32108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nantes', 32157;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Narandiba', 32207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Natividade da Serra', 32306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nazaré Paulista', 32405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Neves Paulista', 32504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nhandeara', 32603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nipoã', 32702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nova Aliança', 32801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nova Campina', 32827;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nova Canaã Paulista', 32843;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nova Castilho', 32868;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nova Europa', 32900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nova Granada', 33007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nova Guataporanga', 33106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nova Independência', 33205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nova Luzitânia', 33304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nova Odessa', 33403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Novais', 33254;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Novo Horizonte', 33502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Nuporanga', 33601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ocauçu', 33700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Óleo', 33809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Olímpia', 33908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Onda Verde', 34005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Oriente', 34104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Orindiúva', 34203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Orlândia', 34302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Osasco', 34401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Oscar Bressane', 34500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Osvaldo Cruz', 34609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ourinhos', 34708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ouro Verde', 34807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ouroeste', 34757;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pacaembu', 34906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Palestina', 35002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Palmares Paulista', 35101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Palmeira d''Oeste', 35200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Palmital', 35309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Panorama', 35408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Paraguaçu Paulista', 35507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Paraibuna', 35606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Paraíso', 35705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Paranapanema', 35804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Paranapuã', 35903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Parapuã', 36000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pardinho', 36109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pariquera-Açu', 36208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Parisi', 36257;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Patrocínio Paulista', 36307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Paulicéia', 36406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Paulínia', 36505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Paulistânia', 36570;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Paulo de Faria', 36604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pederneiras', 36703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pedra Bela', 36802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pedranópolis', 36901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pedregulho', 37008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pedreira', 37107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pedrinhas Paulista', 37156;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pedro de Toledo', 37206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Penápolis', 37305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pereira Barreto', 37404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pereiras', 37503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Peruíbe', 37602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Piacatu', 37701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Piedade', 37800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pilar do Sul', 37909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pindamonhangaba', 38006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pindorama', 38105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pinhalzinho', 38204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Piquerobi', 38303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Piquete', 38501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Piracaia', 38600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Piracicaba', 38709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Piraju', 38808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pirajuí', 38907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pirangi', 39004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pirapora do Bom Jesus', 39103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pirapozinho', 39202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pirassununga', 39301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Piratininga', 39400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pitangueiras', 39509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Planalto', 39608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Platina', 39707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Poá', 39806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Poloni', 39905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pompéia', 40002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pongaí', 40101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pontal', 40200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pontalinda', 40259;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pontes Gestal', 40309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Populina', 40408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Porangaba', 40507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Porto Feliz', 40606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Porto Ferreira', 40705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Potim', 40754;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Potirendaba', 40804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pracinha', 40853;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pradópolis', 40903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Praia Grande', 41000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Pratânia', 41059;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Presidente Alves', 41109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Presidente Bernardes', 41208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Presidente Epitácio', 41307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Presidente Prudente', 41406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Presidente Venceslau', 41505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Promissão', 41604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Quadra', 41653;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Quatá', 41703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Queiroz', 41802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Queluz', 41901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Quintana', 42008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Rafard', 42107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Rancharia', 42206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Redenção da Serra', 42305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Regente Feijó', 42404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Reginópolis', 42503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Registro', 42602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Restinga', 42701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ribeira', 42800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ribeirão Bonito', 42909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ribeirão Branco', 43006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ribeirão Corrente', 43105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ribeirão do Sul', 43204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ribeirão dos Índios', 43238;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ribeirão Grande', 43253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ribeirão Pires', 43303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ribeirão Preto', 43402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Rifaina', 43600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Rincão', 43709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Rinópolis', 43808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Rio Claro', 43907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Rio das Pedras', 44004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Rio Grande da Serra', 44103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Riolândia', 44202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Riversul', 43501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Rosana', 44251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Roseira', 44301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Rubiácea', 44400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Rubinéia', 44509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Sabino', 44608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Sagres', 44707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Sales', 44806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Sales Oliveira', 44905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Salesópolis', 45001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Salmourão', 45100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Saltinho', 45159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Salto', 45209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Salto de Pirapora', 45308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Salto Grande', 45407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Sandovalina', 45506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Adélia', 45605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Albertina', 45704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Bárbara d''Oeste', 45803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Branca', 46009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Clara d''Oeste', 46108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Cruz da Conceição', 46207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Cruz da Esperança', 46256;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Cruz das Palmeiras', 46306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Cruz do Rio Pardo', 46405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Ernestina', 46504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Fé do Sul', 46603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Gertrudes', 46702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Isabel', 46801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Lúcia', 46900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Maria da Serra', 47007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Mercedes', 47106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Rita do Passa Quatro', 47502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Rita d''Oeste', 47403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Rosa de Viterbo', 47601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santa Salete', 47650;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santana da Ponte Pensa', 47205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santana de Parnaíba', 47304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santo Anastácio', 47700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santo André', 47809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santo Antônio da Alegria', 47908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santo Antônio de Posse', 48005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santo Antônio do Aracanguá', 48054;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santo Antônio do Jardim', 48104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santo Antônio do Pinhal', 48203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santo Expedito', 48302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santópolis do Aguapeí', 48401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Santos', 48500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Bento do Sapucaí', 48609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Bernardo do Campo', 48708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Caetano do Sul', 48807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Carlos', 48906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Francisco', 49003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São João da Boa Vista', 49102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São João das Duas Pontes', 49201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São João de Iracema', 49250;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São João do Pau d''Alho', 49300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Joaquim da Barra', 49409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São José da Bela Vista', 49508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São José do Barreiro', 49607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São José do Rio Pardo', 49706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São José do Rio Preto', 49805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São José dos Campos', 49904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Lourenço da Serra', 49953;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Luiz do Paraitinga', 50001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Manuel', 50100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Miguel Arcanjo', 50209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Paulo', 50308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Pedro', 50407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Pedro do Turvo', 50506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Roque', 50605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Sebastião', 50704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Sebastião da Grama', 50803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Simão', 50902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'São Vicente', 51009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Sarapuí', 51108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Sarutaiá', 51207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Sebastianópolis do Sul', 51306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Serra Azul', 51405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Serra Negra', 51603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Serrana', 51504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Sertãozinho', 51702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Sete Barras', 51801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Severínia', 51900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Silveiras', 52007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Socorro', 52106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Sorocaba', 52205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Sud Mennucci', 52304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Sumaré', 52403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Suzanápolis', 52551;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Suzano', 52502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tabapuã', 52601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tabatinga', 52700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Taboão da Serra', 52809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Taciba', 52908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Taguaí', 53005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Taiaçu', 53104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Taiúva', 53203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tambaú', 53302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tanabi', 53401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tapiraí', 53500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tapiratiba', 53609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Taquaral', 53658;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Taquaritinga', 53708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Taquarituba', 53807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Taquarivaí', 53856;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tarabai', 53906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tarumã', 53955;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tatuí', 54003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Taubaté', 54102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tejupá', 54201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Teodoro Sampaio', 54300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Terra Roxa', 54409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tietê', 54508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Timburi', 54607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Torre de Pedra', 54656;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Torrinha', 54706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Trabiju', 54755;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tremembé', 54805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Três Fronteiras', 54904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tuiuti', 54953;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tupã', 55000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Tupi Paulista', 55109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Turiúba', 55208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Turmalina', 55307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ubarana', 55356;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ubatuba', 55406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Ubirajara', 55505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Uchoa', 55604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'União Paulista', 55703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Urânia', 55802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Uru', 55901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Urupês', 56008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Valentim Gentil', 56107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Valinhos', 56206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Valparaíso', 56305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Vargem', 56354;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Vargem Grande do Sul', 56404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Vargem Grande Paulista', 56453;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Várzea Paulista', 56503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Vera Cruz', 56602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Vinhedo', 56701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Viradouro', 56800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Vista Alegre do Alto', 56909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Vitória Brasil', 56958;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Votorantim', 57006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Votuporanga', 57105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 35), 'Zacarias', 57154;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Abatiá', 00103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Adrianópolis', 00202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Agudos do Sul', 00301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Almirante Tamandaré', 00400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Altamira do Paraná', 00459;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Alto Paraíso', 28625;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Alto Paraná', 00608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Alto Piquiri', 00707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Altônia', 00509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Alvorada do Sul', 00806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Amaporã', 00905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ampére', 01002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Anahy', 01051;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Andirá', 01101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ângulo', 01150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Antonina', 01200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Antônio Olinto', 01309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Apucarana', 01408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Arapongas', 01507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Arapoti', 01606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Arapuã', 01655;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Araruna', 01705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Araucária', 01804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ariranha do Ivaí', 01853;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Assaí', 01903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Assis Chateaubriand', 02000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Astorga', 02109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Atalaia', 02208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Balsa Nova', 02307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Bandeirantes', 02406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Barbosa Ferraz', 02505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Barra do Jacaré', 02703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Barracão', 02604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Bela Vista da Caroba', 02752;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Bela Vista do Paraíso', 02802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Bituruna', 02901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Boa Esperança', 03008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Boa Esperança do Iguaçu', 03024;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Boa Ventura de São Roque', 03040;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Boa Vista da Aparecida', 03057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Bocaiúva do Sul', 03107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Bom Jesus do Sul', 03156;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Bom Sucesso', 03206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Bom Sucesso do Sul', 03222;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Borrazópolis', 03305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Braganey', 03354;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Brasilândia do Sul', 03370;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cafeara', 03404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cafelândia', 03453;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cafezal do Sul', 03479;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Califórnia', 03503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cambará', 03602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cambé', 03701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cambira', 03800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Campina da Lagoa', 03909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Campina do Simão', 03958;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Campina Grande do Sul', 04006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Campo Bonito', 04055;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Campo do Tenente', 04105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Campo Largo', 04204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Campo Magro', 04253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Campo Mourão', 04303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cândido de Abreu', 04402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Candói', 04428;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cantagalo', 04451;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Capanema', 04501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Capitão Leônidas Marques', 04600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Carambeí', 04659;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Carlópolis', 04709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cascavel', 04808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Castro', 04907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Catanduvas', 05003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Centenário do Sul', 05102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cerro Azul', 05201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Céu Azul', 05300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Chopinzinho', 05409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cianorte', 05508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cidade Gaúcha', 05607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Clevelândia', 05706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Colombo', 05805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Colorado', 05904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Congonhinhas', 06001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Conselheiro Mairinck', 06100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Contenda', 06209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Corbélia', 06308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cornélio Procópio', 06407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Coronel Domingos Soares', 06456;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Coronel Vivida', 06506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Corumbataí do Sul', 06555;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cruz Machado', 06803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cruzeiro do Iguaçu', 06571;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cruzeiro do Oeste', 06605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cruzeiro do Sul', 06704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Cruzmaltina', 06852;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Curitiba', 06902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Curiúva', 07009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Diamante do Norte', 07108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Diamante do Sul', 07124;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Diamante D''Oeste', 07157;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Dois Vizinhos', 07207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Douradina', 07256;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Doutor Camargo', 07306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Doutor Ulysses', 28633;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Enéas Marques', 07405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Engenheiro Beltrão', 07504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Entre Rios do Oeste', 07538;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Esperança Nova', 07520;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Espigão Alto do Iguaçu', 07546;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Farol', 07553;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Faxinal', 07603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Fazenda Rio Grande', 07652;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Fênix', 07702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Fernandes Pinheiro', 07736;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Figueira', 07751;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Flor da Serra do Sul', 07850;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Floraí', 07801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Floresta', 07900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Florestópolis', 08007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Flórida', 08106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Formosa do Oeste', 08205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Foz do Iguaçu', 08304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Foz do Jordão', 08452;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Francisco Alves', 08320;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Francisco Beltrão', 08403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'General Carneiro', 08502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Godoy Moreira', 08551;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Goioerê', 08601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Goioxim', 08650;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Grandes Rios', 08700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Guaíra', 08809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Guairaçá', 08908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Guamiranga', 08957;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Guapirama', 09005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Guaporema', 09104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Guaraci', 09203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Guaraniaçu', 09302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Guarapuava', 09401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Guaraqueçaba', 09500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Guaratuba', 09609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Honório Serpa', 09658;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ibaiti', 09708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ibema', 09757;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ibiporã', 09807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Icaraíma', 09906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Iguaraçu', 10003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Iguatu', 10052;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Imbaú', 10078;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Imbituva', 10102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Inácio Martins', 10201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Inajá', 10300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Indianópolis', 10409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ipiranga', 10508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Iporã', 10607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Iracema do Oeste', 10656;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Irati', 10706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Iretama', 10805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Itaguajé', 10904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Itaipulândia', 10953;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Itambaracá', 11001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Itambé', 11100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Itapejara d''Oeste', 11209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Itaperuçu', 11258;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Itaúna do Sul', 11308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ivaí', 11407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ivaiporã', 11506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ivaté', 11555;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ivatuba', 11605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Jaboti', 11704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Jacarezinho', 11803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Jaguapitã', 11902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Jaguariaíva', 12009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Jandaia do Sul', 12108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Janiópolis', 12207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Japira', 12306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Japurá', 12405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Jardim Alegre', 12504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Jardim Olinda', 12603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Jataizinho', 12702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Jesuítas', 12751;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Joaquim Távora', 12801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Jundiaí do Sul', 12900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Juranda', 12959;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Jussara', 13007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Kaloré', 13106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Lapa', 13205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Laranjal', 13254;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Laranjeiras do Sul', 13304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Leópolis', 13403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Lidianópolis', 13429;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Lindoeste', 13452;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Loanda', 13502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Lobato', 13601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Londrina', 13700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Luiziana', 13734;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Lunardelli', 13759;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Lupionópolis', 13809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Mallet', 13908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Mamborê', 14005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Mandaguaçu', 14104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Mandaguari', 14203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Mandirituba', 14302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Manfrinópolis', 14351;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Mangueirinha', 14401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Manoel Ribas', 14500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Marechal Cândido Rondon', 14609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Maria Helena', 14708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Marialva', 14807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Marilândia do Sul', 14906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Marilena', 15002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Mariluz', 15101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Maringá', 15200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Mariópolis', 15309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Maripá', 15358;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Marmeleiro', 15408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Marquinho', 15457;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Marumbi', 15507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Matelândia', 15606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Matinhos', 15705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Mato Rico', 15739;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Mauá da Serra', 15754;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Medianeira', 15804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Mercedes', 15853;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Mirador', 15903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Miraselva', 16000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Missal', 16059;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Moreira Sales', 16109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Morretes', 16208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Munhoz de Melo', 16307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nossa Senhora das Graças', 16406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova Aliança do Ivaí', 16505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova América da Colina', 16604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova Aurora', 16703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova Cantu', 16802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova Esperança', 16901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova Esperança do Sudoeste', 16950;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova Fátima', 17008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova Laranjeiras', 17057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova Londrina', 17107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova Olímpia', 17206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova Prata do Iguaçu', 17255;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova Santa Bárbara', 17214;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova Santa Rosa', 17222;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Nova Tebas', 17271;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Novo Itacolomi', 17297;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ortigueira', 17305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ourizona', 17404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ouro Verde do Oeste', 17453;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Paiçandu', 17503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Palmas', 17602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Palmeira', 17701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Palmital', 17800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Palotina', 17909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Paraíso do Norte', 18006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Paranacity', 18105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Paranaguá', 18204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Paranapoema', 18303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Paranavaí', 18402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Pato Bragado', 18451;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Pato Branco', 18501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Paula Freitas', 18600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Paulo Frontin', 18709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Peabiru', 18808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Perobal', 18857;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Pérola', 18907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Pérola d''Oeste', 19004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Piên', 19103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Pinhais', 19152;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Pinhal de São Bento', 19251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Pinhalão', 19202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Pinhão', 19301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Piraí do Sul', 19400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Piraquara', 19509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Pitanga', 19608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Pitangueiras', 19657;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Planaltina do Paraná', 19707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Planalto', 19806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ponta Grossa', 19905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Pontal do Paraná', 19954;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Porecatu', 20002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Porto Amazonas', 20101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Porto Barreiro', 20150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Porto Rico', 20200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Porto Vitória', 20309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Prado Ferreira', 20333;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Pranchita', 20358;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Presidente Castelo Branco', 20408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Primeiro de Maio', 20507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Prudentópolis', 20606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Quarto Centenário', 20655;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Quatiguá', 20705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Quatro Barras', 20804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Quatro Pontes', 20853;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Quedas do Iguaçu', 20903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Querência do Norte', 21000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Quinta do Sol', 21109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Quitandinha', 21208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ramilândia', 21257;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Rancho Alegre', 21307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Rancho Alegre D''Oeste', 21356;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Realeza', 21406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Rebouças', 21505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Renascença', 21604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Reserva', 21703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Reserva do Iguaçu', 21752;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ribeirão Claro', 21802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ribeirão do Pinhal', 21901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Rio Azul', 22008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Rio Bom', 22107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Rio Bonito do Iguaçu', 22156;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Rio Branco do Ivaí', 22172;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Rio Branco do Sul', 22206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Rio Negro', 22305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Rolândia', 22404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Roncador', 22503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Rondon', 22602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Rosário do Ivaí', 22651;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Sabáudia', 22701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Salgado Filho', 22800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Salto do Itararé', 22909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Salto do Lontra', 23006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Amélia', 23105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Cecília do Pavão', 23204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Cruz de Monte Castelo', 23303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Fé', 23402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Helena', 23501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Inês', 23600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Isabel do Ivaí', 23709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Izabel do Oeste', 23808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Lúcia', 23824;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Maria do Oeste', 23857;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Mariana', 23907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Mônica', 23956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Tereza do Oeste', 24020;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santa Terezinha de Itaipu', 24053;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santana do Itararé', 24004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santo Antônio da Platina', 24103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santo Antônio do Caiuá', 24202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santo Antônio do Paraíso', 24301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santo Antônio do Sudoeste', 24400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Santo Inácio', 24509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São Carlos do Ivaí', 24608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São Jerônimo da Serra', 24707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São João', 24806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São João do Caiuá', 24905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São João do Ivaí', 25001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São João do Triunfo', 25100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São Jorge do Ivaí', 25308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São Jorge do Patrocínio', 25357;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São Jorge d''Oeste', 25209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São José da Boa Vista', 25407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São José das Palmeiras', 25456;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São José dos Pinhais', 25506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São Manoel do Paraná', 25555;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São Mateus do Sul', 25605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São Miguel do Iguaçu', 25704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São Pedro do Iguaçu', 25753;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São Pedro do Ivaí', 25803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São Pedro do Paraná', 25902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São Sebastião da Amoreira', 26009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'São Tomé', 26108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Sapopema', 26207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Sarandi', 26256;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Saudade do Iguaçu', 26272;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Sengés', 26306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Serranópolis do Iguaçu', 26355;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Sertaneja', 26405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Sertanópolis', 26504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Siqueira Campos', 26603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Sulina', 26652;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Tamarana', 26678;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Tamboara', 26702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Tapejara', 26801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Tapira', 26900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Teixeira Soares', 27007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Telêmaco Borba', 27106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Terra Boa', 27205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Terra Rica', 27304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Terra Roxa', 27403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Tibagi', 27502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Tijucas do Sul', 27601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Toledo', 27700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Tomazina', 27809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Três Barras do Paraná', 27858;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Tunas do Paraná', 27882;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Tuneiras do Oeste', 27908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Tupãssi', 27957;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Turvo', 27965;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ubiratã', 28005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Umuarama', 28104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'União da Vitória', 28203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Uniflor', 28302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Uraí', 28401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Ventania', 28534;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Vera Cruz do Oeste', 28559;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Verê', 28609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Virmond', 28658;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Vitorino', 28708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Wenceslau Braz', 28500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 41), 'Xambrê', 28807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Abdon Batista', 00051;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Abelardo Luz', 00101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Agrolândia', 00200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Agronômica', 00309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Água Doce', 00408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Águas de Chapecó', 00507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Águas Frias', 00556;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Águas Mornas', 00606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Alfredo Wagner', 00705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Alto Bela Vista', 00754;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Anchieta', 00804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Angelina', 00903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Anita Garibaldi', 01000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Anitápolis', 01109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Antônio Carlos', 01208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Apiúna', 01257;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Arabutã', 01273;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Araquari', 01307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Araranguá', 01406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Armazém', 01505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Arroio Trinta', 01604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Arvoredo', 01653;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ascurra', 01703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Atalanta', 01802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Aurora', 01901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Balneário Arroio do Silva', 01950;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Balneário Barra do Sul', 02057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Balneário Camboriú', 02008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Balneário Gaivota', 02073;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Balneário Piçarras', 12809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Balneário Rincão', 20000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Bandeirante', 02081;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Barra Bonita', 02099;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Barra Velha', 02107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Bela Vista do Toldo', 02131;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Belmonte', 02156;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Benedito Novo', 02206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Biguaçu', 02305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Blumenau', 02404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Bocaina do Sul', 02438;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Bom Jardim da Serra', 02503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Bom Jesus', 02537;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Bom Jesus do Oeste', 02578;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Bom Retiro', 02602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Bombinhas', 02453;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Botuverá', 02701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Braço do Norte', 02800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Braço do Trombudo', 02859;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Brunópolis', 02875;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Brusque', 02909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Caçador', 03006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Caibi', 03105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Calmon', 03154;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Camboriú', 03204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Campo Alegre', 03303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Campo Belo do Sul', 03402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Campo Erê', 03501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Campos Novos', 03600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Canelinha', 03709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Canoinhas', 03808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Capão Alto', 03253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Capinzal', 03907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Capivari de Baixo', 03956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Catanduvas', 04004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Caxambu do Sul', 04103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Celso Ramos', 04152;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Cerro Negro', 04178;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Chapadão do Lageado', 04194;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Chapecó', 04202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Cocal do Sul', 04251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Concórdia', 04301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Cordilheira Alta', 04350;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Coronel Freitas', 04400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Coronel Martins', 04459;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Correia Pinto', 04558;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Corupá', 04509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Criciúma', 04608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Cunha Porã', 04707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Cunhataí', 04756;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Curitibanos', 04806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Descanso', 04905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Dionísio Cerqueira', 05001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Dona Emma', 05100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Doutor Pedrinho', 05159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Entre Rios', 05175;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ermo', 05191;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Erval Velho', 05209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Faxinal dos Guedes', 05308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Flor do Sertão', 05357;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Florianópolis', 05407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Formosa do Sul', 05431;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Forquilhinha', 05456;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Fraiburgo', 05506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Frei Rogério', 05555;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Galvão', 05605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Garopaba', 05704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Garuva', 05803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Gaspar', 05902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Governador Celso Ramos', 06009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Grão-Pará', 06108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Gravatal', 06207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Guabiruba', 06306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Guaraciaba', 06405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Guaramirim', 06504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Guarujá do Sul', 06603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Guatambú', 06652;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Herval d''Oeste', 06702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ibiam', 06751;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ibicaré', 06801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ibirama', 06900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Içara', 07007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ilhota', 07106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Imaruí', 07205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Imbituba', 07304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Imbuia', 07403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Indaial', 07502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Iomerê', 07577;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ipira', 07601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Iporã do Oeste', 07650;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ipuaçu', 07684;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ipumirim', 07700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Iraceminha', 07759;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Irani', 07809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Irati', 07858;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Irineópolis', 07908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Itá', 08005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Itaiópolis', 08104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Itajaí', 08203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Itapema', 08302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Itapiranga', 08401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Itapoá', 08450;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ituporanga', 08500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Jaborá', 08609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Jacinto Machado', 08708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Jaguaruna', 08807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Jaraguá do Sul', 08906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Jardinópolis', 08955;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Joaçaba', 09003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Joinville', 09102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'José Boiteux', 09151;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Jupiá', 09177;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Lacerdópolis', 09201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Lages', 09300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Laguna', 09409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Lajeado Grande', 09458;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Laurentino', 09508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Lauro Müller', 09607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Lebon Régis', 09706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Leoberto Leal', 09805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Lindóia do Sul', 09854;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Lontras', 09904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Luiz Alves', 10001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Luzerna', 10035;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Macieira', 10050;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Mafra', 10100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Major Gercino', 10209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Major Vieira', 10308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Maracajá', 10407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Maravilha', 10506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Marema', 10555;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Massaranduba', 10605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Matos Costa', 10704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Meleiro', 10803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Mirim Doce', 10852;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Modelo', 10902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Mondaí', 11009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Monte Carlo', 11058;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Monte Castelo', 11108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Morro da Fumaça', 11207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Morro Grande', 11256;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Navegantes', 11306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Nova Erechim', 11405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Nova Itaberaba', 11454;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Nova Trento', 11504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Nova Veneza', 11603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Novo Horizonte', 11652;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Orleans', 11702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Otacílio Costa', 11751;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ouro', 11801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ouro Verde', 11850;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Paial', 11876;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Painel', 11892;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Palhoça', 11900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Palma Sola', 12007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Palmeira', 12056;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Palmitos', 12106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Papanduva', 12205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Paraíso', 12239;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Passo de Torres', 12254;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Passos Maia', 12270;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Paulo Lopes', 12304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Pedras Grandes', 12403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Penha', 12502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Peritiba', 12601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Pescaria Brava', 12650;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Petrolândia', 12700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Pinhalzinho', 12908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Pinheiro Preto', 13005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Piratuba', 13104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Planalto Alegre', 13153;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Pomerode', 13203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ponte Alta', 13302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ponte Alta do Norte', 13351;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Ponte Serrada', 13401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Porto Belo', 13500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Porto União', 13609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Pouso Redondo', 13708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Praia Grande', 13807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Presidente Castello Branco', 13906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Presidente Getúlio', 14003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Presidente Nereu', 14102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Princesa', 14151;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Quilombo', 14201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Rancho Queimado', 14300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Rio das Antas', 14409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Rio do Campo', 14508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Rio do Oeste', 14607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Rio do Sul', 14805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Rio dos Cedros', 14706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Rio Fortuna', 14904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Rio Negrinho', 15000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Rio Rufino', 15059;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Riqueza', 15075;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Rodeio', 15109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Romelândia', 15208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Salete', 15307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Saltinho', 15356;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Salto Veloso', 15406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Sangão', 15455;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Santa Cecília', 15505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Santa Helena', 15554;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Santa Rosa de Lima', 15604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Santa Rosa do Sul', 15653;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Santa Terezinha', 15679;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Santa Terezinha do Progresso', 15687;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Santiago do Sul', 15695;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Santo Amaro da Imperatriz', 15703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Bento do Sul', 15802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Bernardino', 15752;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Bonifácio', 15901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Carlos', 16008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Cristóvão do Sul', 16057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Domingos', 16107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Francisco do Sul', 16206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São João Batista', 16305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São João do Itaperiú', 16354;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São João do Oeste', 16255;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São João do Sul', 16404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Joaquim', 16503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São José', 16602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São José do Cedro', 16701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São José do Cerrito', 16800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Lourenço do Oeste', 16909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Ludgero', 17006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Martinho', 17105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Miguel da Boa Vista', 17154;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Miguel do Oeste', 17204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'São Pedro de Alcântara', 17253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Saudades', 17303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Schroeder', 17402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Seara', 17501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Serra Alta', 17550;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Siderópolis', 17600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Sombrio', 17709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Sul Brasil', 17758;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Taió', 17808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Tangará', 17907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Tigrinhos', 17956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Tijucas', 18004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Timbé do Sul', 18103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Timbó', 18202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Timbó Grande', 18251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Três Barras', 18301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Treviso', 18350;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Treze de Maio', 18400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Treze Tílias', 18509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Trombudo Central', 18608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Tubarão', 18707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Tunápolis', 18756;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Turvo', 18806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'União do Oeste', 18855;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Urubici', 18905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Urupema', 18954;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Urussanga', 19002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Vargeão', 19101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Vargem', 19150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Vargem Bonita', 19176;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Vidal Ramos', 19200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Videira', 19309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Vitor Meireles', 19358;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Witmarsum', 19408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Xanxerê', 19507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Xavantina', 19606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Xaxim', 19705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 42), 'Zortéa', 19853;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Aceguá', 00034;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Água Santa', 00059;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Agudo', 00109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ajuricaba', 00208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Alecrim', 00307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Alegrete', 00406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Alegria', 00455;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Almirante Tamandaré do Sul', 00471;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Alpestre', 00505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Alto Alegre', 00554;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Alto Feliz', 00570;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Alvorada', 00604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Amaral Ferrador', 00638;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ametista do Sul', 00646;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'André da Rocha', 00661;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Anta Gorda', 00703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Antônio Prado', 00802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Arambaré', 00851;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Araricá', 00877;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Aratiba', 00901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Arroio do Meio', 01008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Arroio do Padre', 01073;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Arroio do Sal', 01057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Arroio do Tigre', 01206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Arroio dos Ratos', 01107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Arroio Grande', 01305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Arvorezinha', 01404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Augusto Pestana', 01503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Áurea', 01552;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Bagé', 01602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Balneário Pinhal', 01636;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Barão', 01651;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Barão de Cotegipe', 01701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Barão do Triunfo', 01750;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Barra do Guarita', 01859;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Barra do Quaraí', 01875;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Barra do Ribeiro', 01909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Barra do Rio Azul', 01925;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Barra Funda', 01958;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Barracão', 01800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Barros Cassal', 02006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Benjamin Constant do Sul', 02055;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Bento Gonçalves', 02105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Boa Vista das Missões', 02154;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Boa Vista do Buricá', 02204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Boa Vista do Cadeado', 02220;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Boa Vista do Incra', 02238;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Boa Vista do Sul', 02253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Bom Jesus', 02303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Bom Princípio', 02352;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Bom Progresso', 02378;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Bom Retiro do Sul', 02402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Boqueirão do Leão', 02451;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Bossoroca', 02501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Bozano', 02584;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Braga', 02600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Brochier', 02659;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Butiá', 02709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Caçapava do Sul', 02808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cacequi', 02907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cachoeira do Sul', 03004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cachoeirinha', 03103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cacique Doble', 03202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Caibaté', 03301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Caiçara', 03400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Camaquã', 03509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Camargo', 03558;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cambará do Sul', 03608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Campestre da Serra', 03673;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Campina das Missões', 03707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Campinas do Sul', 03806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Campo Bom', 03905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Campo Novo', 04002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Campos Borges', 04101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Candelária', 04200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cândido Godói', 04309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Candiota', 04358;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Canela', 04408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Canguçu', 04507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Canoas', 04606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Canudos do Vale', 04614;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Capão Bonito do Sul', 04622;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Capão da Canoa', 04630;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Capão do Cipó', 04655;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Capão do Leão', 04663;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Capela de Santana', 04689;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Capitão', 04697;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Capivari do Sul', 04671;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Caraá', 04713;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Carazinho', 04705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Carlos Barbosa', 04804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Carlos Gomes', 04853;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Casca', 04903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Caseiros', 04952;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Catuípe', 05009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Caxias do Sul', 05108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Centenário', 05116;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cerrito', 05124;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cerro Branco', 05132;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cerro Grande', 05157;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cerro Grande do Sul', 05173;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cerro Largo', 05207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Chapada', 05306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Charqueadas', 05355;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Charrua', 05371;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Chiapetta', 05405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Chuí', 05439;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Chuvisca', 05447;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cidreira', 05454;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ciríaco', 05504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Colinas', 05587;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Colorado', 05603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Condor', 05702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Constantina', 05801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Coqueiro Baixo', 05835;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Coqueiros do Sul', 05850;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Coronel Barros', 05871;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Coronel Bicaco', 05900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Coronel Pilar', 05934;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cotiporã', 05959;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Coxilha', 05975;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Crissiumal', 06007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cristal', 06056;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cristal do Sul', 06072;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cruz Alta', 06106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cruzaltense', 06130;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Cruzeiro do Sul', 06205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'David Canabarro', 06304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Derrubadas', 06320;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Dezesseis de Novembro', 06353;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Dilermando de Aguiar', 06379;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Dois Irmãos', 06403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Dois Irmãos das Missões', 06429;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Dois Lajeados', 06452;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Dom Feliciano', 06502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Dom Pedrito', 06601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Dom Pedro de Alcântara', 06551;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Dona Francisca', 06700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Doutor Maurício Cardoso', 06734;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Doutor Ricardo', 06759;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Eldorado do Sul', 06767;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Encantado', 06809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Encruzilhada do Sul', 06908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Engenho Velho', 06924;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Entre Rios do Sul', 06957;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Entre-Ijuís', 06932;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Erebango', 06973;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Erechim', 07005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ernestina', 07054;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Erval Grande', 07203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Erval Seco', 07302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Esmeralda', 07401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Esperança do Sul', 07450;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Espumoso', 07500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Estação', 07559;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Estância Velha', 07609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Esteio', 07708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Estrela', 07807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Estrela Velha', 07815;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Eugênio de Castro', 07831;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Fagundes Varela', 07864;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Farroupilha', 07906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Faxinal do Soturno', 08003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Faxinalzinho', 08052;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Fazenda Vilanova', 08078;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Feliz', 08102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Flores da Cunha', 08201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Floriano Peixoto', 08250;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Fontoura Xavier', 08300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Formigueiro', 08409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Forquetinha', 08433;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Fortaleza dos Valos', 08458;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Frederico Westphalen', 08508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Garibaldi', 08607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Garruchos', 08656;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Gaurama', 08706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'General Câmara', 08805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Gentil', 08854;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Getúlio Vargas', 08904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Giruá', 09001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Glorinha', 09050;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Gramado', 09100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Gramado dos Loureiros', 09126;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Gramado Xavier', 09159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Gravataí', 09209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Guabiju', 09258;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Guaíba', 09308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Guaporé', 09407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Guarani das Missões', 09506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Harmonia', 09555;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Herval', 07104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Herveiras', 09571;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Horizontina', 09605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Hulha Negra', 09654;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Humaitá', 09704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ibarama', 09753;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ibiaçá', 09803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ibiraiaras', 09902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ibirapuitã', 09951;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ibirubá', 10009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Igrejinha', 10108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ijuí', 10207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ilópolis', 10306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Imbé', 10330;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Imigrante', 10363;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Independência', 10405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Inhacorá', 10413;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ipê', 10439;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ipiranga do Sul', 10462;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Iraí', 10504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Itaara', 10538;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Itacurubi', 10553;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Itapuca', 10579;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Itaqui', 10603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Itati', 10652;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Itatiba do Sul', 10702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ivorá', 10751;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ivoti', 10801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Jaboticaba', 10850;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Jacuizinho', 10876;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Jacutinga', 10900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Jaguarão', 11007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Jaguari', 11106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Jaquirana', 11122;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Jari', 11130;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Jóia', 11155;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Júlio de Castilhos', 11205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Lagoa Bonita do Sul', 11239;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Lagoa dos Três Cantos', 11270;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Lagoa Vermelha', 11304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Lagoão', 11254;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Lajeado', 11403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Lajeado do Bugre', 11429;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Lavras do Sul', 11502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Liberato Salzano', 11601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Lindolfo Collor', 11627;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Linha Nova', 11643;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Maçambará', 11718;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Machadinho', 11700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Mampituba', 11734;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Manoel Viana', 11759;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Maquiné', 11775;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Maratá', 11791;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Marau', 11809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Marcelino Ramos', 11908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Mariana Pimentel', 11981;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Mariano Moro', 12005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Marques de Souza', 12054;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Mata', 12104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Mato Castelhano', 12138;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Mato Leitão', 12153;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Mato Queimado', 12179;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Maximiliano de Almeida', 12203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Minas do Leão', 12252;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Miraguaí', 12302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Montauri', 12351;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Monte Alegre dos Campos', 12377;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Monte Belo do Sul', 12385;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Montenegro', 12401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Mormaço', 12427;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Morrinhos do Sul', 12443;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Morro Redondo', 12450;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Morro Reuter', 12476;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Mostardas', 12500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Muçum', 12609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Muitos Capões', 12617;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Muliterno', 12625;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Não-Me-Toque', 12658;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nicolau Vergueiro', 12674;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nonoai', 12708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Alvorada', 12757;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Araçá', 12807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Bassano', 12906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Boa Vista', 12955;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Bréscia', 13003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Candelária', 13011;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Esperança do Sul', 13037;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Hartz', 13060;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Pádua', 13086;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Palma', 13102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Petrópolis', 13201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Prata', 13300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Ramada', 13334;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Roma do Sul', 13359;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Nova Santa Rita', 13375;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Novo Barreiro', 13490;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Novo Cabrais', 13391;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Novo Hamburgo', 13409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Novo Machado', 13425;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Novo Tiradentes', 13441;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Novo Xingu', 13466;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Osório', 13508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Paim Filho', 13607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Palmares do Sul', 13656;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Palmeira das Missões', 13706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Palmitinho', 13805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Panambi', 13904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pantano Grande', 13953;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Paraí', 14001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Paraíso do Sul', 14027;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pareci Novo', 14035;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Parobé', 14050;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Passa Sete', 14068;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Passo do Sobrado', 14076;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Passo Fundo', 14100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Paulo Bento', 14134;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Paverama', 14159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pedras Altas', 14175;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pedro Osório', 14209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pejuçara', 14308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pelotas', 14407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Picada Café', 14423;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pinhal', 14456;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pinhal da Serra', 14464;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pinhal Grande', 14472;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pinheirinho do Vale', 14498;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pinheiro Machado', 14506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pinto Bandeira', 14548;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pirapó', 14555;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Piratini', 14605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Planalto', 14704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Poço das Antas', 14753;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pontão', 14779;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ponte Preta', 14787;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Portão', 14803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Porto Alegre', 14902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Porto Lucena', 15008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Porto Mauá', 15057;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Porto Vera Cruz', 15073;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Porto Xavier', 15107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Pouso Novo', 15131;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Presidente Lucena', 15149;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Progresso', 15156;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Protásio Alves', 15172;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Putinga', 15206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Quaraí', 15305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Quatro Irmãos', 15313;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Quevedos', 15321;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Quinze de Novembro', 15354;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Redentora', 15404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Relvado', 15453;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Restinga Sêca', 15503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Rio dos Índios', 15552;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Rio Grande', 15602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Rio Pardo', 15701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Riozinho', 15750;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Roca Sales', 15800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Rodeio Bonito', 15909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Rolador', 15958;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Rolante', 16006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ronda Alta', 16105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Rondinha', 16204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Roque Gonzales', 16303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Rosário do Sul', 16402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sagrada Família', 16428;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Saldanha Marinho', 16436;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Salto do Jacuí', 16451;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Salvador das Missões', 16477;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Salvador do Sul', 16501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sananduva', 16600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santa Bárbara do Sul', 16709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santa Cecília do Sul', 16733;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santa Clara do Sul', 16758;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santa Cruz do Sul', 16808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santa Margarida do Sul', 16972;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santa Maria', 16907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santa Maria do Herval', 16956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santa Rosa', 17202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santa Tereza', 17251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santa Vitória do Palmar', 17301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santana da Boa Vista', 17004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sant''Ana do Livramento', 17103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santiago', 17400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santo Ângelo', 17509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santo Antônio da Patrulha', 17608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santo Antônio das Missões', 17707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santo Antônio do Palma', 17558;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santo Antônio do Planalto', 17756;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santo Augusto', 17806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santo Cristo', 17905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Santo Expedito do Sul', 17954;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Borja', 18002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Domingos do Sul', 18051;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Francisco de Assis', 18101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Francisco de Paula', 18200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Gabriel', 18309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Jerônimo', 18408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São João da Urtiga', 18424;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São João do Polêsine', 18432;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Jorge', 18440;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São José das Missões', 18457;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São José do Herval', 18465;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São José do Hortêncio', 18481;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São José do Inhacorá', 18499;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São José do Norte', 18507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São José do Ouro', 18606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São José do Sul', 18614;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São José dos Ausentes', 18622;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Leopoldo', 18705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Lourenço do Sul', 18804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Luiz Gonzaga', 18903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Marcos', 19000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Martinho', 19109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Martinho da Serra', 19125;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Miguel das Missões', 19158;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Nicolau', 19208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Paulo das Missões', 19307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Pedro da Serra', 19356;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Pedro das Missões', 19364;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Pedro do Butiá', 19372;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Pedro do Sul', 19406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Sebastião do Caí', 19505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Sepé', 19604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Valentim', 19703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Valentim do Sul', 19711;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Valério do Sul', 19737;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Vendelino', 19752;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'São Vicente do Sul', 19802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sapiranga', 19901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sapucaia do Sul', 20008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sarandi', 20107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Seberi', 20206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sede Nova', 20230;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Segredo', 20263;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Selbach', 20305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Senador Salgado Filho', 20321;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sentinela do Sul', 20354;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Serafina Corrêa', 20404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sério', 20453;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sertão', 20503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sertão Santana', 20552;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sete de Setembro', 20578;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Severiano de Almeida', 20602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Silveira Martins', 20651;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sinimbu', 20677;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Sobradinho', 20701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Soledade', 20800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tabaí', 20859;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tapejara', 20909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tapera', 21006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tapes', 21105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Taquara', 21204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Taquari', 21303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Taquaruçu do Sul', 21329;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tavares', 21352;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tenente Portela', 21402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Terra de Areia', 21436;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Teutônia', 21451;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tio Hugo', 21469;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tiradentes do Sul', 21477;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Toropi', 21493;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Torres', 21501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tramandaí', 21600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Travesseiro', 21626;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Três Arroios', 21634;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Três Cachoeiras', 21667;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Três Coroas', 21709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Três de Maio', 21808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Três Forquilhas', 21832;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Três Palmeiras', 21857;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Três Passos', 21907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Trindade do Sul', 21956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Triunfo', 22004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tucunduva', 22103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tunas', 22152;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tupanci do Sul', 22186;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tupanciretã', 22202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tupandi', 22251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Tuparendi', 22301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Turuçu', 22327;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Ubiretama', 22343;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'União da Serra', 22350;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Unistalda', 22376;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Uruguaiana', 22400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vacaria', 22509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vale do Sol', 22533;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vale Real', 22541;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vale Verde', 22525;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vanini', 22558;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Venâncio Aires', 22608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vera Cruz', 22707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Veranópolis', 22806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vespasiano Corrêa', 22855;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Viadutos', 22905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Viamão', 23002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vicente Dutra', 23101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Victor Graeff', 23200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vila Flores', 23309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vila Lângaro', 23358;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vila Maria', 23408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vila Nova do Sul', 23457;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vista Alegre', 23507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vista Alegre do Prata', 23606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vista Gaúcha', 23705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Vitória das Missões', 23754;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Westfália', 23770;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 43), 'Xangri-lá', 23804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Água Clara', 00203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Alcinópolis', 00252;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Amambai', 00609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Anastácio', 00708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Anaurilândia', 00807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Angélica', 00856;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Antônio João', 00906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Aparecida do Taboado', 01003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Aquidauana', 01102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Aral Moreira', 01243;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Bandeirantes', 01508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Bataguassu', 01904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Batayporã', 02001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Bela Vista', 02100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Bodoquena', 02159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Bonito', 02209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Brasilândia', 02308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Caarapó', 02407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Camapuã', 02605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Campo Grande', 02704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Caracol', 02803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Cassilândia', 02902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Chapadão do Sul', 02951;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Corguinho', 03108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Coronel Sapucaia', 03157;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Corumbá', 03207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Costa Rica', 03256;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Coxim', 03306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Deodápolis', 03454;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Dois Irmãos do Buriti', 03488;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Douradina', 03504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Dourados', 03702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Eldorado', 03751;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Fátima do Sul', 03801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Figueirão', 03900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Glória de Dourados', 04007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Guia Lopes da Laguna', 04106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Iguatemi', 04304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Inocência', 04403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Itaporã', 04502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Itaquiraí', 04601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Ivinhema', 04700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Japorã', 04809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Jaraguari', 04908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Jardim', 05004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Jateí', 05103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Juti', 05152;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Ladário', 05202;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Laguna Carapã', 05251;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Maracaju', 05400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Miranda', 05608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Mundo Novo', 05681;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Naviraí', 05707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Nioaque', 05806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Nova Alvorada do Sul', 06002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Nova Andradina', 06200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Novo Horizonte do Sul', 06259;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Paraíso das Águas', 06275;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Paranaíba', 06309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Paranhos', 06358;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Pedro Gomes', 06408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Ponta Porã', 06606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Porto Murtinho', 06903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Ribas do Rio Pardo', 07109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Rio Brilhante', 07208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Rio Negro', 07307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Rio Verde de Mato Grosso', 07406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Rochedo', 07505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Santa Rita do Pardo', 07554;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'São Gabriel do Oeste', 07695;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Selvíria', 07802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Sete Quedas', 07703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Sidrolândia', 07901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Sonora', 07935;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Tacuru', 07950;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Taquarussu', 07976;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Terenos', 08008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Três Lagoas', 08305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 50), 'Vicentina', 08404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Acorizal', 00102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Água Boa', 00201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Alta Floresta', 00250;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Alto Araguaia', 00300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Alto Boa Vista', 00359;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Alto Garças', 00409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Alto Paraguai', 00508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Alto Taquari', 00607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Apiacás', 00805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Araguaiana', 01001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Araguainha', 01209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Araputanga', 01258;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Arenápolis', 01308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Aripuanã', 01407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Barão de Melgaço', 01605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Barra do Bugres', 01704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Barra do Garças', 01803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Boa Esperança do Norte', 01837;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Bom Jesus do Araguaia', 01852;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Brasnorte', 01902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Cáceres', 02504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Campinápolis', 02603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Campo Novo do Parecis', 02637;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Campo Verde', 02678;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Campos de Júlio', 02686;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Canabrava do Norte', 02694;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Canarana', 02702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Carlinda', 02793;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Castanheira', 02850;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Chapada dos Guimarães', 03007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Cláudia', 03056;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Cocalinho', 03106;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Colíder', 03205;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Colniza', 03254;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Comodoro', 03304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Confresa', 03353;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Conquista D''Oeste', 03361;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Cotriguaçu', 03379;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Cuiabá', 03403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Curvelândia', 03437;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Denise', 03452;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Diamantino', 03502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Dom Aquino', 03601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Feliz Natal', 03700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Figueirópolis D''Oeste', 03809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Gaúcha do Norte', 03858;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'General Carneiro', 03908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Glória D''Oeste', 03957;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Guarantã do Norte', 04104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Guiratinga', 04203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Indiavaí', 04500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Ipiranga do Norte', 04526;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Itanhangá', 04542;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Itaúba', 04559;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Itiquira', 04609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Jaciara', 04807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Jangada', 04906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Jauru', 05002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Juara', 05101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Juína', 05150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Juruena', 05176;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Juscimeira', 05200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Lambari D''Oeste', 05234;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Lucas do Rio Verde', 05259;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Luciara', 05309;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Marcelândia', 05580;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Matupá', 05606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Mirassol d''Oeste', 05622;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nobres', 05903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nortelândia', 06000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nossa Senhora do Livramento', 06109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Bandeirantes', 06158;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Brasilândia', 06208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Canaã do Norte', 06216;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Guarita', 08808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Lacerda', 06182;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Marilândia', 08857;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Maringá', 08907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Monte Verde', 08956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Mutum', 06224;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Nazaré', 06174;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Olímpia', 06232;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Santa Helena', 06190;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Ubiratã', 06240;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Nova Xavantina', 06257;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Novo Horizonte do Norte', 06273;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Novo Mundo', 06265;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Novo Santo Antônio', 06315;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Novo São Joaquim', 06281;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Paranaíta', 06299;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Paranatinga', 06307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Pedra Preta', 06372;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Peixoto de Azevedo', 06422;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Planalto da Serra', 06455;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Poconé', 06505;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Pontal do Araguaia', 06653;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Ponte Branca', 06703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Pontes e Lacerda', 06752;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Porto Alegre do Norte', 06778;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Porto dos Gaúchos', 06802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Porto Esperidião', 06828;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Porto Estrela', 06851;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Poxoréu', 07008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Primavera do Leste', 07040;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Querência', 07065;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Reserva do Cabaçal', 07156;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Ribeirão Cascalheira', 07180;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Ribeirãozinho', 07198;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Rio Branco', 07206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Rondolândia', 07578;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Rondonópolis', 07602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Rosário Oeste', 07701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Salto do Céu', 07750;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Santa Carmem', 07248;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Santa Cruz do Xingu', 07743;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Santa Rita do Trivelato', 07768;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Santa Terezinha', 07776;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Santo Afonso', 07263;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Santo Antônio de Leverger', 07800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Santo Antônio do Leste', 07792;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'São Félix do Araguaia', 07859;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'São José do Povo', 07297;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'São José do Rio Claro', 07305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'São José do Xingu', 07354;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'São José dos Quatro Marcos', 07107;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'São Pedro da Cipa', 07404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Sapezal', 07875;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Serra Nova Dourada', 07883;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Sinop', 07909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Sorriso', 07925;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Tabaporã', 07941;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Tangará da Serra', 07958;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Tapurah', 08006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Terra Nova do Norte', 08055;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Tesouro', 08105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Torixoréu', 08204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'União do Sul', 08303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Vale de São Domingos', 08352;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Várzea Grande', 08402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Vera', 08501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Vila Bela da Santíssima Trindade', 05507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 51), 'Vila Rica', 08600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Abadia de Goiás', 00050;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Abadiânia', 00100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Acreúna', 00134;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Adelândia', 00159;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Água Fria de Goiás', 00175;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Água Limpa', 00209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Águas Lindas de Goiás', 00258;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Alexânia', 00308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Aloândia', 00506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Alto Horizonte', 00555;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Alto Paraíso de Goiás', 00605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Alvorada do Norte', 00803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Amaralina', 00829;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Americano do Brasil', 00852;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Amorinópolis', 00902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Anápolis', 01108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Anhanguera', 01207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Anicuns', 01306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Aparecida de Goiânia', 01405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Aparecida do Rio Doce', 01454;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Aporé', 01504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Araçu', 01603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Aragarças', 01702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Aragoiânia', 01801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Araguapaz', 02155;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Arenópolis', 02353;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Aruanã', 02502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Aurilândia', 02601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Avelinópolis', 02809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Baliza', 03104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Barro Alto', 03203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Bela Vista de Goiás', 03302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Bom Jardim de Goiás', 03401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Bom Jesus de Goiás', 03500;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Bonfinópolis', 03559;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Bonópolis', 03575;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Brazabrantes', 03609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Britânia', 03807;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Buriti Alegre', 03906;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Buriti de Goiás', 03939;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Buritinópolis', 03962;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Cabeceiras', 04003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Cachoeira Alta', 04102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Cachoeira de Goiás', 04201;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Cachoeira Dourada', 04250;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Caçu', 04300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Caiapônia', 04409;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Caldas Novas', 04508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Caldazinha', 04557;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Campestre de Goiás', 04607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Campinaçu', 04656;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Campinorte', 04706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Campo Alegre de Goiás', 04805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Campo Limpo de Goiás', 04854;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Campos Belos', 04904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Campos Verdes', 04953;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Carmo do Rio Verde', 05000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Castelândia', 05059;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Catalão', 05109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Caturaí', 05208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Cavalcante', 05307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Ceres', 05406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Cezarina', 05455;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Chapadão do Céu', 05471;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Cidade Ocidental', 05497;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Cocalzinho de Goiás', 05513;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Colinas do Sul', 05521;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Córrego do Ouro', 05703;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Corumbá de Goiás', 05802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Corumbaíba', 05901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Cristalina', 06206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Cristianópolis', 06305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Crixás', 06404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Cromínia', 06503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Cumari', 06602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Damianópolis', 06701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Damolândia', 06800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Davinópolis', 06909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Diorama', 07105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Divinópolis de Goiás', 08301;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Doverlândia', 07253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Edealina', 07352;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Edéia', 07402;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Estrela do Norte', 07501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Faina', 07535;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Fazenda Nova', 07600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Firminópolis', 07808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Flores de Goiás', 07907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Formosa', 08004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Formoso', 08103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Gameleira de Goiás', 08152;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Goianápolis', 08400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Goiandira', 08509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Goianésia', 08608;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Goiânia', 08707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Goianira', 08806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Goiás', 08905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Goiatuba', 09101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Gouvelândia', 09150;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Guapó', 09200;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Guaraíta', 09291;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Guarani de Goiás', 09408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Guarinos', 09457;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Heitoraí', 09606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Hidrolândia', 09705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Hidrolina', 09804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Iaciara', 09903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Inaciolândia', 09937;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Indiara', 09952;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Inhumas', 10000;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Ipameri', 10109;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Ipiranga de Goiás', 10158;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Iporá', 10208;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Israelândia', 10307;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Itaberaí', 10406;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Itaguari', 10562;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Itaguaru', 10604;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Itajá', 10802;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Itapaci', 10901;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Itapirapuã', 11008;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Itapuranga', 11206;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Itarumã', 11305;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Itauçu', 11404;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Itumbiara', 11503;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Ivolândia', 11602;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Jandaia', 11701;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Jaraguá', 11800;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Jataí', 11909;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Jaupaci', 12006;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Jesúpolis', 12055;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Joviânia', 12105;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Jussara', 12204;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Lagoa Santa', 12253;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Leopoldo de Bulhões', 12303;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Luziânia', 12501;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Mairipotaba', 12600;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Mambaí', 12709;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Mara Rosa', 12808;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Marzagão', 12907;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Matrinchã', 12956;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Maurilândia', 13004;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Mimoso de Goiás', 13053;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Minaçu', 13087;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Mineiros', 13103;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Moiporá', 13400;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Monte Alegre de Goiás', 13509;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Montes Claros de Goiás', 13707;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Montividiu', 13756;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Montividiu do Norte', 13772;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Morrinhos', 13806;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Morro Agudo de Goiás', 13855;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Mossâmedes', 13905;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Mozarlândia', 14002;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Mundo Novo', 14051;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Mutunópolis', 14101;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Nazário', 14408;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Nerópolis', 14507;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Niquelândia', 14606;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Nova América', 14705;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Nova Aurora', 14804;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Nova Crixás', 14838;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Nova Glória', 14861;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Nova Iguaçu de Goiás', 14879;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Nova Roma', 14903;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Nova Veneza', 15009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Novo Brasil', 15207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Novo Gama', 15231;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Novo Planalto', 15256;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Orizona', 15306;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Ouro Verde de Goiás', 15405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Ouvidor', 15504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Padre Bernardo', 15603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Palestina de Goiás', 15652;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Palmeiras de Goiás', 15702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Palmelo', 15801;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Palminópolis', 15900;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Panamá', 16007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Paranaiguara', 16304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Paraúna', 16403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Perolândia', 16452;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Petrolina de Goiás', 16809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Pilar de Goiás', 16908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Piracanjuba', 17104;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Piranhas', 17203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Pirenópolis', 17302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Pires do Rio', 17401;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Planaltina', 17609;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Pontalina', 17708;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Porangatu', 18003;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Porteirão', 18052;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Portelândia', 18102;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Posse', 18300;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Professor Jamil', 18391;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Quirinópolis', 18508;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Rialma', 18607;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Rianápolis', 18706;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Rio Quente', 18789;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Rio Verde', 18805;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Rubiataba', 18904;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Sanclerlândia', 19001;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Santa Bárbara de Goiás', 19100;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Santa Cruz de Goiás', 19209;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Santa Fé de Goiás', 19258;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Santa Helena de Goiás', 19308;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Santa Isabel', 19357;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Santa Rita do Araguaia', 19407;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Santa Rita do Novo Destino', 19456;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Santa Rosa de Goiás', 19506;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Santa Tereza de Goiás', 19605;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Santa Terezinha de Goiás', 19704;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Santo Antônio da Barra', 19712;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Santo Antônio de Goiás', 19738;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Santo Antônio do Descoberto', 19753;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'São Domingos', 19803;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'São Francisco de Goiás', 19902;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'São João da Paraúna', 20058;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'São João d''Aliança', 20009;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'São Luís de Montes Belos', 20108;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'São Luiz do Norte', 20157;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'São Miguel do Araguaia', 20207;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'São Miguel do Passa Quatro', 20264;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'São Patrício', 20280;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'São Simão', 20405;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Senador Canedo', 20454;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Serranópolis', 20504;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Silvânia', 20603;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Simolândia', 20686;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Sítio d''Abadia', 20702;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Taquaral de Goiás', 21007;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Teresina de Goiás', 21080;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Terezópolis de Goiás', 21197;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Três Ranchos', 21304;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Trindade', 21403;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Trombas', 21452;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Turvânia', 21502;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Turvelândia', 21551;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Uirapuru', 21577;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Uruaçu', 21601;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Uruana', 21700;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Urutaí', 21809;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Valparaíso de Goiás', 21858;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Varjão', 21908;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Vianópolis', 22005;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Vicentinópolis', 22054;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Vila Boa', 22203;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 52), 'Vila Propício', 22302;
INSERT INTO city (state_id, name, ibge_code)  SELECT (SELECT state.state_id FROM state WHERE state.ibge_code = 53), 'Brasília', 00108;

REVOKE INSERT, UPDATE, DELETE ON city FROM public; --tabela referencia
GRANT SELECT ON city TO public;

CREATE TABLE IF NOT EXISTS public.address
(
    address_id serial,
    city_id integer NOT NULL,
    postal_code character varying(8) COLLATE pg_catalog."default" NOT NULL,
    street character varying(150) COLLATE pg_catalog."default" NOT NULL,
    "number" character varying(40) COLLATE pg_catalog."default" NOT NULL,
    neighborhood character varying(100) COLLATE pg_catalog."default" NOT NULL,
    complement character varying(100) COLLATE pg_catalog."default",
    reference character varying(150) COLLATE pg_catalog."default",
    CONSTRAINT address_pkey PRIMARY KEY (address_id),
    CONSTRAINT address_city_id_fkey FOREIGN KEY (city_id)
        REFERENCES public.city (city_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.address
    OWNER to quero_doar;

COMMENT ON TABLE public.address
    IS 'Armazena informações de localização física utilizadas no sistema, podendo representar o endereço residencial de um usuário ou o ponto de retirada de uma doação.
';

CREATE TABLE IF NOT EXISTS public."user"
(
    user_id serial,
    address_id integer,
    email character varying(150) COLLATE pg_catalog."default" NOT NULL,
    name character varying(150) COLLATE pg_catalog."default" NOT NULL,
    cpf character varying(11) COLLATE pg_catalog."default",
    birthday date,
    password_hash text COLLATE pg_catalog."default" NOT NULL,
    is_active boolean NOT NULL,
    verified boolean NOT NULL,
    is_admin boolean NOT NULL,
    cell_phone character varying(11) COLLATE pg_catalog."default",
    home_phone character varying(10) COLLATE pg_catalog."default",
    whatsapp character varying(15) COLLATE pg_catalog."default",
    CONSTRAINT user_pkey PRIMARY KEY (user_id),
    CONSTRAINT user_cpf_key UNIQUE (cpf),
    CONSTRAINT user_email_key UNIQUE (email),
    CONSTRAINT user_address_id_fkey FOREIGN KEY (address_id)
        REFERENCES public.address (address_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public."user"
    OWNER to quero_doar;

COMMENT ON TABLE public."user"
    IS 'Tabela que armazena os dados dos usuários do sistema. Contém informações pessoais, credenciais de acesso e status de atividade.';

COMMENT ON COLUMN public."user".email
    IS 'e-mail no padrão RFC5322.';

COMMENT ON COLUMN public."user".password_hash
    IS 'Armazena o hash da senha do usuário gerado com o algoritmo Argon2id.
Inclui os parâmetros de configuração (memória, tempo, paralelismo), o salt aleatório e o hash derivado, todos codificados em uma única string.
Utilizado para autenticação segura e resistente a ataques de força bruta e GPU.
O formato segue o padrão: $argon2id$v=19$m=...,t=...,p=...$salt$hash';

CREATE INDEX idx_user_active_verified ON public."user"(is_active, verified, is_admin);
CREATE INDEX idx_user_address_id ON public."user"(address_id);

CREATE TABLE IF NOT EXISTS public.log_type
(
    log_type_id serial,
    identifier character varying(10) COLLATE pg_catalog."default" NOT NULL,
    name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT log_type_pkey PRIMARY KEY (log_type_id),
    CONSTRAINT log_type_identifier_key UNIQUE (identifier)
);

ALTER TABLE IF EXISTS public.log_type
    OWNER to quero_doar;

COMMENT ON TABLE public.log_type
    IS 'Tabela que armazena os tipos de log. Usada por tabelas de registros/log.';

INSERT INTO public.log_type (identifier, name) VALUES
                                                   ('CREATE', 'Criação'),
                                                   ('UPDATE', 'Atualização'),
                                                   ('DELETE', 'Exclusão'),
                                                   ('INACTIVATE', 'Inativação'),
                                                   ('LOGIN', 'Entrar'),
                                                   ('LOGOUT', 'Sair'),
                                                   ('BLOCK', 'Bloqueio'),
                                                   ('REPORT', 'Denúncia');

REVOKE INSERT, UPDATE, DELETE ON log_type FROM public; --tabela referencia
GRANT SELECT ON log_type TO public;

CREATE TABLE IF NOT EXISTS public.user_log
(
    user_log_id serial,
    log_type_id integer NOT NULL,
    user_id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    data jsonb,
    CONSTRAINT user_log_pkey PRIMARY KEY (user_log_id),
    CONSTRAINT user_log_log_type_id_fkey FOREIGN KEY (log_type_id)
        REFERENCES public.log_type (log_type_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT user_log_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public."user" (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.user_log
    OWNER to quero_doar;

COMMENT ON TABLE public.user_log
    IS 'Tabela que armazena os registros de log de cada usuário.';

CREATE TABLE IF NOT EXISTS public.user_blocking
(
    user_id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    until timestamp with time zone,
    reason character varying(1000) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT user_blocking_pkey PRIMARY KEY (user_id),
    CONSTRAINT user_blocking_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public."user" (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.user_blocking
    OWNER to quero_doar;

COMMENT ON TABLE public.user_blocking
    IS 'Tabela que armazena os dados sobre bloqueio de usuários.';

COMMENT ON COLUMN public.user_blocking.until
    IS 'Quando não informado => Bloqueio definitivo';

CREATE INDEX idx_user_blocking_date_until ON user_blocking (date, until);

CREATE TABLE IF NOT EXISTS public.user_report
(
    user_report_id serial,
    reporting_user_id integer NOT NULL,
    reported_user_id integer NOT NULL,
    reason character varying(1000) COLLATE pg_catalog."default" NOT NULL,
    status "char" NOT NULL CHECK (status IN ('P', 'A', 'R')),
    date timestamp with time zone NOT NULL,
    CONSTRAINT user_report_pkey PRIMARY KEY (user_report_id),
    CONSTRAINT user_report_reported_user_id_fkey FOREIGN KEY (reported_user_id)
        REFERENCES public."user" (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT user_report_reporting_user_id_fkey FOREIGN KEY (reporting_user_id)
        REFERENCES public."user" (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.user_report
    OWNER to quero_doar;

COMMENT ON TABLE public.user_report
    IS 'Tabela que armazena informações sobre denúncias de usuários.';

COMMENT ON COLUMN public.user_report.status
    IS 'P => Pendente
A => Aceito
R => Recusado';

CREATE INDEX idx_user_report_status ON user_report (status);

CREATE TABLE IF NOT EXISTS public.category
(
    category_id serial,
    name character varying(60) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT category_pkey PRIMARY KEY (category_id)
);

ALTER TABLE IF EXISTS public.category
    OWNER to quero_doar;

COMMENT ON TABLE public.category
    IS 'Tabela que armazena as categorias de objetos a serem doados.';

CREATE INDEX idx_category_name ON category (name);

INSERT INTO public.category (category_id, name) VALUES
                                                    (1, 'Roupas'),
                                                    (2, 'Móveis'),
                                                    (3, 'Utensílios Domésticos'),
                                                    (4, 'Livros e Material Escolar'),
                                                    (5, 'Brinquedos'),
                                                    (6, 'Eletrônicos'),
                                                    (7, 'Saúde e Higiene'),
                                                    (8, 'Pets'),
                                                    (9, 'Alimentos'),
                                                    (10, 'Itens para Bebês'),
                                                    (11, 'Ferramentas e Materiais'),
                                                    (12, 'Outros');

REVOKE INSERT, UPDATE, DELETE ON category FROM public; --tabela referencia
GRANT SELECT ON category TO public;

CREATE TABLE IF NOT EXISTS public.subcategory
(
    subcategory_id serial,
    category_id integer NOT NULL,
    name character varying(60) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT subcategory_pkey PRIMARY KEY (subcategory_id),
    CONSTRAINT subcategory_category_id_fkey FOREIGN KEY (category_id)
        REFERENCES public.category (category_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

ALTER TABLE IF EXISTS public.subcategory
    OWNER to quero_doar;

COMMENT ON TABLE public.subcategory
    IS 'Tabela que armazena as subcategorias de objetos a serem doados.';

CREATE INDEX idx_subcategory_name ON subcategory (name);

INSERT INTO public.subcategory (category_id, name) VALUES
                                                       -- Roupas
                                                       (1, 'Adulto Masculino'),
                                                       (1, 'Adulto Feminino'),
                                                       (1, 'Infantil'),
                                                       (1, 'Bebê'),
                                                       (1, 'Calçados'),
                                                       (1, 'Acessórios'),
                                                       (1, 'Outros'),
                                                       -- Móveis
                                                       (2, 'Cama'),
                                                       (2, 'Sofá'),
                                                       (2, 'Mesa'),
                                                       (2, 'Cadeira'),
                                                       (2, 'Guarda-roupa'),
                                                       (2, 'Berço'),
                                                       (2, 'Outros'),
                                                       -- Utensílios Domésticos
                                                       (3, 'Cozinha'),
                                                       (3, 'Limpeza'),
                                                       (3, 'Decoração'),
                                                       (3, 'Outros'),
                                                       -- Livros e Material Escolar
                                                       (4, 'Livros Didáticos'),
                                                       (4, 'Literatura'),
                                                       (4, 'Cadernos'),
                                                       (4, 'Mochilas'),
                                                       (4, 'Lápis e Canetas'),
                                                       (4, 'Outros'),
                                                       -- Brinquedos
                                                       (5, 'Educativos'),
                                                       (5, 'Eletrônicos'),
                                                       (5, 'Jogos de Tabuleiro'),
                                                       (5, 'Pelúcias'),
                                                       (5, 'Outros'),
                                                       -- Eletrônicos
                                                       (6, 'Celulares'),
                                                       (6, 'Computadores'),
                                                       (6, 'Tablets'),
                                                       (6, 'Eletrodomésticos'),
                                                       (6, 'Outros'),
                                                       -- Saúde e Higiene
                                                       (7, 'Fraldas'),
                                                       (7, 'Absorventes'),
                                                       (7, 'Higiene Pessoal'),
                                                       (7, 'Equipamentos Médicos'),
                                                       (7, 'Outros'),
                                                       -- Pets
                                                       (8, 'Ração'),
                                                       (8, 'Brinquedos'),
                                                       (8, 'Camas'),
                                                       (8, 'Acessórios'),
                                                       (8, 'Outros'),
                                                       -- Alimentos
                                                       (9, 'Não Perecíveis'),
                                                       (9, 'Cestas Básicas'),
                                                       (9, 'Bebidas'),
                                                       (9, 'Produtos Orgânicos'),
                                                       (9, 'Outros'),
                                                       -- Itens para Bebês
                                                       (10, 'Roupas'),
                                                       (10, 'Mamadeiras'),
                                                       (10, 'Carrinhos'),
                                                       (10, 'Banheiras'),
                                                       (10, 'Outros'),
                                                       -- Ferramentas e Materiais
                                                       (11, 'Ferramentas Manuais'),
                                                       (11, 'Materiais de Construção'),
                                                       (11, 'Equipamentos de Jardinagem'),
                                                       (11, 'Outros'),
                                                       -- Categoria Outros
                                                       (12, 'Outros');

REVOKE INSERT, UPDATE, DELETE ON subcategory FROM public; --tabela referencia
GRANT SELECT ON subcategory TO public;

CREATE TABLE IF NOT EXISTS public.donation
(
    donation_id serial,
    creator_user_id integer NOT NULL,
    target_user_id integer,
    address_id integer NOT NULL,
    subcategory_id integer NOT NULL,
    type "char" NOT NULL CHECK(type IN ('D', 'P')),
    status "char" NOT NULL CHECK (status IN ('D', 'R', 'F')),
    title character varying(100) COLLATE pg_catalog."default" NOT NULL,
    description character varying(1000) COLLATE pg_catalog."default" NOT NULL,
    photos character varying(256)[] COLLATE pg_catalog."default",
    is_public boolean NOT NULL,
    creator_rating numeric(2,1),
    creator_feedback character varying(1000) COLLATE pg_catalog."default",
    target_rating numeric(2,1),
    target_feedback character varying(1000) COLLATE pg_catalog."default",
    CONSTRAINT donation_pkey PRIMARY KEY (donation_id),
    CONSTRAINT donation_creator_target_diff CHECK (
        target_user_id IS NULL OR target_user_id <> creator_user_id
        ),
    CONSTRAINT donation_address_id_fkey FOREIGN KEY (address_id)
        REFERENCES public.address (address_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT donation_creator_user_id_fkey FOREIGN KEY (creator_user_id)
        REFERENCES public."user" (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT donation_subcategory_id_fkey FOREIGN KEY (subcategory_id)
        REFERENCES public.subcategory (subcategory_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT donation_target_user_id_fkey FOREIGN KEY (target_user_id)
        REFERENCES public."user" (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.donation
    OWNER to quero_doar;

COMMENT ON TABLE public.donation
    IS 'A tabela donation registra as intenções de doação dentro do sistema, podendo representar tanto itens oferecidos por usuários quanto desejos de recebimento.';

COMMENT ON COLUMN public.donation.type
    IS 'D = Doação
P = Pedido de doação';

COMMENT ON COLUMN public.donation.is_public
    IS 'Indica se a doação é pública (Contatos disponíveis para usuários logados) ou privada (Requer solicitação de contato e aceite do doador)';

CREATE INDEX idx_creator_user ON donation (creator_user_id);
CREATE INDEX idx_target_user ON donation (target_user_id);
CREATE INDEX idx_address ON donation (address_id);
CREATE INDEX idx_subcategory ON donation (subcategory_id);
CREATE INDEX idx_public_status ON donation (is_public, status);
CREATE INDEX idx_type ON donation (type);

CREATE TABLE IF NOT EXISTS public.keyword
(
    keyword_id serial,
    keyword character varying(60) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT keyword_pkey PRIMARY KEY (keyword_id),
    CONSTRAINT keyword_keyword_key UNIQUE (keyword)
);

ALTER TABLE IF EXISTS public.keyword
    OWNER to quero_doar;

COMMENT ON TABLE public.keyword
    IS 'A tabela keyword armazena palavras-chave extraídas ou associadas aos títulos das ofertas registradas no sistema. Seu objetivo é agilizar e aprimorar o processo de busca por doações, permitindo que os usuários encontrem itens de forma mais eficiente e relevante.';

CREATE INDEX idx_keyword_prefix ON keyword (keyword);

CREATE TABLE IF NOT EXISTS public.donation_keyword
(
    keyword_id integer NOT NULL,
    donation_id integer NOT NULL,
    CONSTRAINT donation_keyword_pkey PRIMARY KEY (keyword_id, donation_id),
    CONSTRAINT donation_keyword_donation_id_fkey FOREIGN KEY (donation_id)
        REFERENCES public.donation (donation_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT donation_keyword_keyword_id_fkey FOREIGN KEY (keyword_id)
        REFERENCES public.keyword (keyword_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.donation_keyword
    OWNER to quero_doar;

COMMENT ON TABLE public.donation_keyword
    IS 'Relação entre donation e keyword N,N';

CREATE INDEX idx_donation_keyword_donation_id ON donation_keyword (donation_id);
CREATE INDEX idx_donation_keyword_keyword_id ON donation_keyword (keyword_id);

CREATE TABLE IF NOT EXISTS public.donation_report
(
    donation_report_id serial,
    user_id integer NOT NULL,
    donation_id integer NOT NULL,
    date time with time zone NOT NULL,
    reason character varying(1000) COLLATE pg_catalog."default" NOT NULL,
    status "char" NOT NULL CHECK (status IN ('P', 'A', 'R')),
    CONSTRAINT donation_report_pkey PRIMARY KEY (donation_report_id),
    CONSTRAINT donation_report_donation_id_fkey FOREIGN KEY (donation_id)
        REFERENCES public.donation (donation_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT donation_report_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public."user" (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.donation_report
    OWNER to quero_doar;

COMMENT ON TABLE public.donation_report
    IS 'Tabela que armazena as denúncias realizadas em doações.';

CREATE INDEX idx_donation_report_status ON donation_report (status);

CREATE TABLE IF NOT EXISTS public.donation_log
(
    donation_log_id serial,
    log_type_id integer NOT NULL,
    donation_id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    data jsonb,
    CONSTRAINT donation_log_pkey PRIMARY KEY (donation_log_id),
    CONSTRAINT donation_log_donation_id_fkey FOREIGN KEY (donation_id)
        REFERENCES public.donation (donation_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT donation_log_log_type_id_fkey FOREIGN KEY (log_type_id)
        REFERENCES public.log_type (log_type_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.donation_log
    OWNER to quero_doar;

COMMENT ON TABLE public.donation_log
    IS 'Tabela que armazena os registros de logs de doações';

CREATE TABLE IF NOT EXISTS public.interested
(
    donation_id integer NOT NULL,
    user_id integer NOT NULL,
    description character varying(1000) COLLATE pg_catalog."default",
    date timestamp with time zone NOT NULL,
    status "char" NOT NULL CHECK (status IN('P', 'A', 'D')),
    CONSTRAINT interested_pkey PRIMARY KEY (donation_id, user_id),
    CONSTRAINT interested_donation_id_fkey FOREIGN KEY (donation_id)
        REFERENCES public.donation (donation_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT interested_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public."user" (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.interested
    OWNER to quero_doar;

COMMENT ON TABLE public.interested
    IS 'A tabela interested registra os usuários que demonstraram interesse em uma doação cujo anúncio está configurado como restrito. Nesses casos, o anunciante opta por não disponibilizar seus dados de contato publicamente, permitindo acesso apenas aos interessados que ele aceitar.';

COMMENT ON COLUMN public.interested.status
    IS 'P => Pendente
A => Aceita
D => Descartada';

CREATE INDEX idx_interested_donation ON interested (donation_id);
CREATE INDEX idx_interested_user ON interested (user_id);
CREATE INDEX idx_interested_status ON interested (status);
CREATE INDEX idx_interested_date ON interested (date);
CREATE INDEX idx_interested_donation_status ON interested (donation_id, status);

CREATE TABLE IF NOT EXISTS public.level
(
    level_id serial,
    level numeric(4,0) NOT NULL,
    description character varying(60) COLLATE pg_catalog."default" NOT NULL,
    exp_required integer NOT NULL,
    CONSTRAINT level_pkey PRIMARY KEY (level_id)
);

ALTER TABLE IF EXISTS public.level
    OWNER to quero_doar;

COMMENT ON TABLE public.level
    IS 'Tabela de referência que armazena informações sobre cada level atingível no sistema de gaming.';

INSERT INTO public.level (level, description, exp_required) VALUES
                                                                (1,  'Aprendiz Solidário', 0),
                                                                (2,  'Ajudante Novato', 50),
                                                                (3,  'Pagem da Bondade', 120),
                                                                (4,  'Escudeiro Generoso', 200),
                                                                (5,  'Protetor de Causas', 300),
                                                                (6,  'Herói de Um Sorriso', 420),
                                                                (7,  'Mensageiro da Esperança', 560),
                                                                (8,  'Guardião de Afetos', 720),
                                                                (9,  'Campeão da Compaixão', 900),
                                                                (10, 'Mestre da Empatia', 1100),
                                                                (11, 'Patrono Gentil', 1320),
                                                                (12, 'Arquiteto de Oportunidades', 1560),
                                                                (13, 'Semeador de Sorrisos', 1820),
                                                                (14, 'Iluminador de Caminhos', 2100),
                                                                (15, 'Estrategista do Bem', 2400),
                                                                (16, 'Provedor de Esperança', 2720),
                                                                (17, 'Curador de Histórias', 3060),
                                                                (18, 'Guerreiro da Generosidade', 3420),
                                                                (19, 'Mentor de Gestos', 3800),
                                                                (20, 'Embaixador da Solidariedade', 4200),
                                                                (21, 'Guardião de Corações', 4620),
                                                                (22, 'Magnata do Bem', 5060),
                                                                (23, 'Forjador de Destinos', 5520),
                                                                (24, 'Alquimista da Alegria', 6000),
                                                                (25, 'Visionário da Generosidade', 6500),
                                                                (26, 'Paladino da Partilha', 7020),
                                                                (27, 'Defensor da Esperança', 7560),
                                                                (28, 'Criador de Pontes', 8120),
                                                                (29, 'Inspiração Viva', 8700),
                                                                (30, 'Guardião Supremo do Bem', 9300),
                                                                (31, 'Arcanista da Empatia', 9920),
                                                                (32, 'Oráculo Solidário', 10560),
                                                                (33, 'Tecelão de Comunidades', 11220),
                                                                (34, 'Protetor Lendário de Causas', 11900),
                                                                (35, 'Luz Inabalável', 12600),
                                                                (36, 'Guardião Imortal do Bem', 13320),
                                                                (37, 'Avatar da Compaixão', 14060),
                                                                (38, 'Mestre Supremo da Esperança', 14820),
                                                                (39, 'Líder Épico da Solidariedade', 15600),
                                                                (40, 'Portador da Chama do Bem', 16400),
                                                                (41, 'Campeão Celestial', 17220),
                                                                (42, 'Guardião das Estrelas', 18060),
                                                                (43, 'Protetor dos Mundos', 18920),
                                                                (44, 'Arcanjo da Generosidade', 19800),
                                                                (45, 'Sábio Eterno do Bem', 20700),
                                                                (46, 'Divindade da Esperança', 21620),
                                                                (47, 'Mítico Guardião Universal', 22560),
                                                                (48, 'Lenda Viva da Solidariedade', 23520),
                                                                (49, 'Herói Imortal das Doações', 24500),
                                                                (50, 'Avatar Supremo da Luz', 25500);

REVOKE INSERT, UPDATE, DELETE ON level FROM public; --tabela referencia
GRANT SELECT ON level TO public;

CREATE TABLE IF NOT EXISTS public.leveling
(
    user_id integer NOT NULL,
    experience integer NOT NULL,
    level_id integer NOT NULL,
    is_active boolean NOT NULL,
    CONSTRAINT leveling_pkey PRIMARY KEY (user_id),
    CONSTRAINT leveling_level_id_fkey FOREIGN KEY (level_id)
        REFERENCES public.level (level_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT leveling_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public."user" (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.leveling
    OWNER to quero_doar;

COMMENT ON TABLE public.leveling
    IS 'Tabela que armazena dados de gaming de cada usuário.';

CREATE INDEX idx_leveling_level_id ON leveling (level_id);
CREATE INDEX idx_leveling_experience ON leveling (experience);
CREATE INDEX idx_leveling_level_exp ON leveling (level_id, experience DESC);

CREATE TABLE IF NOT EXISTS public.donation_achievement
(
    donation_achievement_id serial,
    donation_type "char" NOT NULL CHECK(donation_type IN ('D', 'P')),
    amount integer NOT NULL,
    description character varying(60) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT donation_achievement_pkey PRIMARY KEY (donation_achievement_id)
);

ALTER TABLE IF EXISTS public.donation_achievement
    OWNER to quero_doar;

COMMENT ON TABLE public.donation_achievement
    IS 'Tabela que armazena os registros de conquistas referente a quantidade de doações feitas por usuários';

INSERT INTO donation_achievement (donation_type, amount, description) VALUES
                                                                          ('D', 1, 'Primeira Faísca'),
                                                                          ('D', 5, 'Coração Generoso'),
                                                                          ('D', 10, 'Doação Constante'),
                                                                          ('D', 25, 'Aliado da Esperança'),
                                                                          ('D', 50, 'Mão Estendida'),
                                                                          ('D', 100, 'Herói Anônimo'),
                                                                          ('D', 250, 'Luz na Escuridão'),
                                                                          ('D', 500, 'Símbolo de Generosidade'),
                                                                          ('P', 1, 'Semeador de Ajuda'),
                                                                          ('P', 3, 'Mobilizador Local'),
                                                                          ('P', 5, 'Voz Solidária'),
                                                                          ('P', 10, 'Conector de Esperança'),
                                                                          ('P', 20, 'Agente da Mudança'),
                                                                          ('P', 50, 'Líder Humanitário'),
                                                                          ('P', 100, 'Arquitetador de Impacto');

REVOKE INSERT, UPDATE, DELETE ON donation_achievement FROM public; --tabela referencia
GRANT SELECT ON donation_achievement TO public;

CREATE TABLE IF NOT EXISTS public.leveling_donation_achievement
(
    user_id integer NOT NULL,
    donation_achievement_id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    CONSTRAINT leveling_donation_achievement_pkey PRIMARY KEY (user_id, donation_achievement_id),
    CONSTRAINT leveling_donation_achievement_donation_achievement_id_fkey FOREIGN KEY (donation_achievement_id)
        REFERENCES public.donation_achievement (donation_achievement_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT leveling_donation_achievement_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public.leveling (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.leveling_donation_achievement
    OWNER to quero_doar;

COMMENT ON TABLE public.leveling_donation_achievement
    IS 'Tabela de relação entre leveling e donation_achievement N para N';

CREATE INDEX idx_lda_user_id ON leveling_donation_achievement (user_id);
CREATE INDEX idx_lda_achievement_id ON leveling_donation_achievement (donation_achievement_id);
CREATE INDEX idx_lda_date ON leveling_donation_achievement (date);
CREATE INDEX idx_lda_achievement_user ON leveling_donation_achievement (donation_achievement_id, user_id);

CREATE TABLE IF NOT EXISTS public.feedback_achievement
(
    feedback_achievement_id serial,
    amount integer NOT NULL,
    description character varying(60) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT feedback_achievement_pkey PRIMARY KEY (feedback_achievement_id)
);

COMMENT ON TABLE public.feedback_achievement
    IS 'Tabela que armazena os registros de conquistas referente a quantidade de feedback feitas por usuários';

INSERT INTO feedback_achievement (amount, description) VALUES
                                                           (1, 'Primeira Palavra'),
                                                           (3, 'Voz Ativa'),
                                                           (5, 'Observador Atento'),
                                                           (10, 'Crítico Construtivo'),
                                                           (15, 'Colaborador Engajado'),
                                                           (20, 'Analista da Comunidade'),
                                                           (30, 'Mentor de Melhorias'),
                                                           (40, 'Consultor de Impacto'),
                                                           (50, 'Especialista em Evolução'),
                                                           (75, 'Influenciador Interno'),
                                                           (100, 'Arquiteto de Experiência'),
                                                           (150, 'Visionário do Sistema'),
                                                           (200, 'Guardião da Qualidade'),
                                                           (300, 'Mestre do Feedback'),
                                                           (500, 'Lenda da Colaboração');

ALTER TABLE IF EXISTS public.feedback_achievement
    OWNER to quero_doar;

REVOKE INSERT, UPDATE, DELETE ON feedback_achievement FROM public; --tabela referencia
GRANT SELECT ON feedback_achievement TO public;

CREATE TABLE IF NOT EXISTS public.leveling_feedback_achievement
(
    user_id integer NOT NULL,
    feedback_achievement_id integer NOT NULL,
    date time with time zone NOT NULL,
    CONSTRAINT leveling_feedback_achievement_pkey PRIMARY KEY (user_id, feedback_achievement_id),
    CONSTRAINT leveling_feedback_achievement_feedback_achievement_id_fkey FOREIGN KEY (feedback_achievement_id)
        REFERENCES public.feedback_achievement (feedback_achievement_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT leveling_feedback_achievement_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public.leveling (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.leveling_feedback_achievement
    OWNER to quero_doar;

COMMENT ON TABLE public.leveling_feedback_achievement
    IS 'Tabela de relação entre leveling e feedback_achievement N para N';

CREATE INDEX idx_lfa_user_id ON leveling_feedback_achievement (user_id);
CREATE INDEX idx_lfa_achievement_id ON leveling_feedback_achievement (feedback_achievement_id);
CREATE INDEX idx_lfa_date ON leveling_feedback_achievement (date);
CREATE INDEX idx_lfa_achievement_user ON leveling_feedback_achievement (feedback_achievement_id, user_id);

CREATE TABLE IF NOT EXISTS public.indicator
(
    indicator_id serial,
    table_column character varying(80) COLLATE pg_catalog."default" NOT NULL,
    domain "char" NOT NULL,
    indicator character varying(60) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT indicator_pkey PRIMARY KEY (indicator_id)
);

ALTER TABLE IF EXISTS public.indicator
    OWNER to quero_doar;

COMMENT ON TABLE public.indicator
    IS 'Tabela de dicionário de significado de status e tipos.';

CREATE INDEX idx_indicator_domain ON indicator (domain);

INSERT INTO indicator (table_column, domain, indicator) VALUES
                                                            ('donation.type', 'D', 'Doação'),
                                                            ('donation.type', 'P', 'Pedido de doação'),
                                                            ('donation.status', 'D', 'Disponível'),
                                                            ('donation.status', 'R', 'Reservado'),
                                                            ('donation.status', 'F', 'Finalizado'),
                                                            ('user_report.status', 'P', 'Pendente'),
                                                            ('user_report.status', 'A', 'Aceito'),
                                                            ('user_report.status', 'R', 'Recusado'),
                                                            ('donation_report.status', 'P', 'Pendente'),
                                                            ('donation_report.status', 'A', 'Aceito'),
                                                            ('donation_report.status', 'R', 'Recusado');

REVOKE INSERT, UPDATE, DELETE ON indicator FROM public; --tabela referencia
GRANT SELECT ON indicator TO public;

CREATE TABLE IF NOT EXISTS public.progression_guide
(
    progression_guide_id serial,
    identifier character varying(80) COLLATE pg_catalog."default" NOT NULL,
    description character varying(150) COLLATE pg_catalog."default" NOT NULL,
    exp_points integer NOT NULL,
    CONSTRAINT progression_guide_pkey PRIMARY KEY (progression_guide_id)
);

ALTER TABLE IF EXISTS public.progression_guide
    OWNER to quero_doar;

COMMENT ON TABLE public.progression_guide
    IS 'Tabela de referencia de progressão para o sistema de gaming';

--Visões
CREATE OR REPLACE VIEW public.v_user_statistic
AS
SELECT u.user_id,
       count(*) FILTER (WHERE d.creator_rating IS NOT NULL AND d.creator_user_id = u.user_id OR d.target_rating IS NOT NULL AND d.target_user_id = u.user_id) AS feedback_count,
       count(*) FILTER (WHERE d.creator_feedback IS NOT NULL AND d.creator_user_id = u.user_id OR d.target_feedback IS NOT NULL AND d.target_user_id = u.user_id) AS feedback_with_comment_count,
       count(*) FILTER (WHERE d.status = 'F'::"char" AND (d.creator_user_id = u.user_id OR d.target_user_id = u.user_id)) AS total_donation_count,
       count(*) FILTER (WHERE d.status = 'F'::"char" AND (d.creator_user_id = u.user_id AND d.type = 'D'::"char" OR d.target_user_id = u.user_id AND d.type = 'P'::"char")) AS send_donation_count,
       count(*) FILTER (WHERE d.status = 'F'::"char" AND (d.creator_user_id = u.user_id AND d.type = 'P'::"char" OR d.target_user_id = u.user_id AND d.type = 'D'::"char")) AS receive_donation_count,
       clvl.level AS current_level,
       l.experience AS current_exp,
       lvl.level AS next_level,
       lvl.exp_required - l.experience AS exp_points_to_next_level
FROM "user" u
         JOIN leveling l USING (user_id)
         LEFT JOIN LATERAL ( SELECT level.exp_required, level.level
                             FROM level
                             WHERE level.exp_required > l.experience
                             ORDER BY level.exp_required
                             LIMIT 1) lvl ON true
         JOIN level clvl ON l.level_id = clvl.level_id
         LEFT JOIN donation d ON d.creator_user_id = u.user_id OR d.target_user_id = u.user_id
GROUP BY u.user_id, l.experience, lvl.exp_required, clvl.level, l.experience, lvl.level;

ALTER TABLE public.v_user_statistic
    OWNER TO quero_doar;

CREATE OR REPLACE VIEW public.v_category
AS
SELECT category.category_id,
       subcategory.subcategory_id,
       category.name AS category,
       subcategory.name AS subcategory
FROM category
         JOIN subcategory USING (category_id);

ALTER TABLE public.v_category
    OWNER TO quero_doar;

CREATE OR REPLACE VIEW public.v_address
AS
SELECT address.address_id,
       address.city_id,
       city.state_id,
       address.postal_code,
       address.street,
       address.number,
       address.neighborhood,
       address.complement,
       address.reference,
       city.name AS city,
       concat(state.ibge_code::text, lpad(city.ibge_code::text, 5, '0'::text)) AS city_ibge_code,
       state.name AS state,
       state.acronym AS state_acronym,
       concat(state.ibge_code::text) AS state_ibge_code
FROM address
         JOIN city USING (city_id)
         JOIN state USING (state_id);

ALTER TABLE public.v_address
    OWNER TO quero_doar;

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

CREATE OR REPLACE VIEW public.v_user_donation_achievement
AS
SELECT lda.user_id,
       da.donation_achievement_id,
       lda.date,
       da.amount,
       da.donation_type,
       id.indicator AS donation_type_indicator,
       da.description
FROM leveling_donation_achievement lda
         JOIN donation_achievement da USING (donation_achievement_id)
         LEFT JOIN indicator id ON id.domain = da.donation_type AND id.table_column::text = 'donation.type'::text;

ALTER TABLE public.v_user_donation_achievement
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
       u.is_admin,
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
GROUP BY u.user_id, u.name, u.email, u.cell_phone, u.home_phone, u.whatsapp, u.is_active, u.verified, u.is_admin, ling.experience, l.level, va.*;

ALTER TABLE public.v_user
    OWNER TO quero_doar;

--Processos / Gatilhos
CREATE OR REPLACE PROCEDURE p_update_feedback_achievements(p_user_id INTEGER)
    LANGUAGE plpgsql
AS $$
DECLARE
    achievement_id INTEGER;
    feedback_count INTEGER;
BEGIN
    SELECT v_user_statistic.feedback_count
    INTO feedback_count
    FROM v_user_statistic
    WHERE user_id = p_user_id;

    FOR achievement_id IN (
        SELECT feedback_achievement_id
        FROM feedback_achievement
        WHERE amount <= feedback_count
    )
        LOOP
            IF NOT EXISTS (
                SELECT 1
                FROM leveling_feedback_achievement
                WHERE user_id = p_user_id
                  AND feedback_achievement_id = achievement_id
            ) THEN
                INSERT INTO leveling_feedback_achievement (user_id, feedback_achievement_id, date) VALUES
                    (p_user_id, achievement_id, CURRENT_TIMESTAMP);
            END IF;
        END LOOP;
END;
$$;

ALTER PROCEDURE public.p_update_feedback_achievements(integer)
    OWNER TO quero_doar;

CREATE OR REPLACE PROCEDURE p_update_donation_achievements(p_user_id INTEGER)
    LANGUAGE plpgsql
AS $$
DECLARE
    achievement_id INTEGER;
    l_send_donation_count INTEGER;
    l_receive_donation_count INTEGER;
BEGIN
    SELECT v_user_statistic.send_donation_count
    INTO l_send_donation_count
    FROM v_user_statistic
    WHERE user_id = p_user_id;

    SELECT v_user_statistic.receive_donation_count
    INTO l_receive_donation_count
    FROM v_user_statistic
    WHERE user_id = p_user_id;

    FOR achievement_id IN (
        SELECT donation_achievement_id
        FROM donation_achievement
        WHERE (amount <= l_send_donation_count
            and donation_type = 'D')
           or (amount <= l_receive_donation_count
            and donation_type = 'P')
    )
        LOOP
            IF NOT EXISTS (
                SELECT 1
                FROM leveling_donation_achievement
                WHERE user_id = p_user_id
                  AND donation_achievement_id = achievement_id
            ) THEN
                INSERT INTO leveling_donation_achievement (user_id, donation_achievement_id, date) VALUES
                    (p_user_id, achievement_id, CURRENT_TIMESTAMP);
            END IF;
        END LOOP;
END;
$$;

ALTER PROCEDURE public.p_update_donation_achievements(integer)
    OWNER TO quero_doar;

CREATE OR REPLACE PROCEDURE p_update_user_level(p_user_id INTEGER)
    LANGUAGE plpgsql
AS $$
DECLARE
    l_user_exp INTEGER;
    l_user_level_id INTEGER;
    l_new_user_level_id INTEGER;
BEGIN
    SELECT leveling.experience, leveling.level_id
    INTO l_user_exp, l_user_level_id
    FROM leveling
    WHERE user_id = p_user_id;

    SELECT level.level_id
    INTO l_new_user_level_id
    FROM level
    WHERE exp_required <= l_user_exp
    ORDER BY exp_required DESC
    LIMIT 1;

    IF l_user_level_id <> l_new_user_level_id
    THEN
        UPDATE leveling
        SET level_id = l_new_user_level_id
        WHERE user_id = p_user_id;
    END IF;
END;
$$;

ALTER PROCEDURE public.p_update_user_level(integer)
    OWNER TO quero_doar;

END;