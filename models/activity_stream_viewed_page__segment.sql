
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
    , p.timestamp as ts
    , p.anonymous_id AS anonymous_customer_id
    , p.user_id AS customer
    , 'viewed_page' as activity
    , null as revenue_impact
    , p.url as link
    , *
    from page_views p
)

select * from {{ activity_schema.make_activity('final') }}
