/*
======================================================================================
Autor:          Kauê Gomes
Data:           21/09/2025
Projeto:        Quero Doar – Adiciona donation.status a v_donation_preview e
                f_donation_preview_final.
Versão:         7.0
Descrição:
    Adiciona status da doação à view de DonationPreview e a função que incluí
    o retorno com distâncias para filtro por stauts.
======================================================================================
*/

BEGIN;

    DROP FUNCTION IF EXISTS f_donation_preview_final(text);
    DROP VIEW IF EXISTS v_donation_preview;

    --Adiciona a coluna v_donation_preview.status
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
    from donation
             inner join address on donation.address_id = address.address_id
             inner join city on address.city_id = city.city_id
             inner join state on city.state_id = state.state_id
             inner join donation_log on donation.donation_id = donation_log.donation_id
        and donation_log.log_type_id = (select log_type_id from log_type where  identifier = 'CREATE')
             inner join "user" on donation.creator_user_id = "user".user_id;

    -- Adiciona a coluna status no retorno da função f_donation_preview_final
    CREATE OR REPLACE FUNCTION f_donation_preview_final(city_name text)
        RETURNS TABLE (
                          donation_id int,
                          title text,
                          description text,
                          photo text,
                          is_donation boolean,
                          is_public boolean,
                          location text,
                          date timestamp,
                          user_minimal json,
                          status character,
                          distance_km double precision
                      )
        LANGUAGE sql
    AS $$
    WITH origin AS (
        SELECT c.location_cube
        FROM city c
        WHERE c.name = city_name
        LIMIT 1
    ),
         distance AS (
             SELECT d.city_id, d.distance_km
             FROM origin o,
                  f_city_distance_km(o.location_cube) d
         )
    SELECT
        v.donation_id,
        v.title,
        v.description,
        v.photo,
        v.is_donation,
        v.is_public,
        v.location,
        v.date,
        v.user_minimal,
        v.status,
        dist.distance_km
    FROM v_donation_preview v
             JOIN distance dist ON v.city_id = dist.city_id
    $$;
END;