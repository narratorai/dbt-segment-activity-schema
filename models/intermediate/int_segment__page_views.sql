with source as (
    select * from {{ var('segment_page_views_table') }}
),

page_views as (
    select 
        p.timestamp
        , p.message_id
        , p.anonymous_id
        , p.user_id
        , p.url
        , RTRIM(p.path, '/') as path
        , p.referrer as referrer
        , (p.context_ip)::varchar(250) as ip_address 
        , (p.context_device_type)::varchar(250) as device
        , p.referrer::varchar(250) as referral_url
        , replace( 
            left(REGEXP_REPLACE(p.referrer::varchar(250), '^(https?://)?(www\.)?', ''), STRPOS(REGEXP_REPLACE(p.referrer::varchar(250), '^(https?://)?(www\.)?', ''), '/')) 
        , '/','') as referring_domain

        , (p.context_page_title)::varchar(250) as page_title
        , nullif ( substring ( regexp_substr ( lower(p.url) ,  'fbclid=[^&]*' ) , 8 ) , '' )::varchar(250) 
            as fbclid

        , nullif ( substring ( regexp_substr ( lower(p.url) , 'gclid=[^&]*' ) , 7 ) , '' )::varchar(250) 
            as gclid

        , nullif ( substring ( regexp_substr ( lower(p.url) , 'utm_source=[^&]*' ) , 12 ) , '' )::varchar(250) 
            as utm_source

        , nullif ( substring ( regexp_substr ( lower(p.url) , 'utm_medium=[^&]*' ) , 12 ) , '' )::varchar(250) 
            as utm_medium

        , nullif ( substring ( regexp_substr ( lower(p.url) , 'utm_campaign=[^&]*' ) , 14 ) , '' )::varchar(250) 
            as utm_campaign

        , nullif ( substring ( regexp_substr ( lower(p.url) , 'utm_content=[^&]*' ) , 13 ) , '' )::varchar ( 250 ) 
            as utm_content
        , case
            when utm_source = 'linkedin' 
            and utm_medium = 'cpc' then 'LinkedIn'
            else null end as ad_source

    from source as p
)

select * from page_views