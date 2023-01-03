
{# 
    Why do we subtract 1 second from the session 'ts'?
    We are using the first page_view to represent a session but technically a session starts right before that. 
    We subtract 1 second to handle that case. This ensures that saying 'give me all page views after a session' 
    returns the first page view too.
#}


{# List of columns that will be brought into the feature_json object #}
{{ config(features=['path', 'referrer', 'ip_address', 'device', 
    'referral_url', 'referring_domain', 'fbclid', 'gclid', 
    'utm_source', 'utm_medium', 'utm_campaign', 'utm_content', 'ad_source']) }}

with page_views as (
    select *
    from {{ ref('int_segment__page_views') }} 
),

final as (
    select
        md5(p.message_id || p.timestamp) as activity_id
        , DATE_ADD('second', -1, p.timestamp) as ts

        , p.anonymous_id as anonymous_customer_id
        , p.user_id as "customer"
        
        , 'started_session' as activity

        , NULL as revenue_impact
        , p.url as link
        , *
    from (
        select
            *,
            lag (p.timestamp) over ( partition by coalesce(p.anonymous_id, p.user_id) order by p.timestamp ) as "last_ts"
        from page_views as p
    ) as p

    where {{ datediff("p.last_ts", "p.timestamp", "minute") }} >= 30
    or last_ts is null
)

select * from {{ activity_schema.make_activity('final') }}