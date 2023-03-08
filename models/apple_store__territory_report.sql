with app as (

    select * 
    from {{ var('app') }}
),

app_store_territory as (

    select *
    from {{ var('app_store_territory') }}
),

country_codes as (

    select * 
    from {{ var('apple_store_country_codes') }}
),

downloads_territory as (

    select *
    from {{ var('downloads_territory') }} 
),

downloads_territory_summed as (
    select
        date_day,
        app_id,
        sum(first_time_downloads),
        sum(redownloads),
        sum(total_downloads)
    from downloads_territory
    group by date_day, app_id
)

downloads_overview as (
    select *
    from {{ ref('int_apple_store__downloads_overview') }}
),

downloads_territory_filled as (
    select * from downloads_territory
    union all
    select 
        date_day, 
        app_id,
        "Unavailable" as source_type,
        NULL as territory,
        (o.first_time_downloads - t.first_time_downloads) as first_time_downloads,
        (o.redownloads - t.redownloads) as redownloads,
        (o.total_downloads - t.total_downloads) as total_downloads
    from downloads_overview o join downloads_territory_summed t on(o.date_day = t.date_day and o.app_id = t.app_id)
),

reporting_grain as (
    select distinct
        date_day,
        app_id,
        source_type,
        territory 
    from app_store_territory
),

joined as (
    select 
        reporting_grain.date_day,
        reporting_grain.app_id,
        app.app_name,
        reporting_grain.source_type,
        reporting_grain.territory as territory_long,
        coalesce(official_country_codes.country_code_alpha_2, alternative_country_codes.country_code_alpha_2) as territory_short,
        coalesce(official_country_codes.region, alternative_country_codes.region) as region,
        coalesce(official_country_codes.sub_region, alternative_country_codes.sub_region) as sub_region,
        coalesce(app_store_territory.impressions, 0) as impressions,
        coalesce(app_store_territory.impressions_unique_device, 0) as impressions_unique_device,
        coalesce(app_store_territory.page_views, 0) as page_views,
        coalesce(app_store_territory.page_views_unique_device, 0) as page_views_unique_device,
        coalesce(downloads_territory_filled.first_time_downloads, 0) as first_time_downloads,
        coalesce(downloads_territory_filled.redownloads, 0) as redownloads,
        coalesce(downloads_territory_filled.total_downloads, 0) as total_downloads,
        CAST(0 as int64) as active_devices,
        CAST(0 as int64) as active_devices_last_30_days,
        CAST(0 as int64) as deletions,
        CAST(0 as int64) as installations,
        CAST(0 as int64) as sessions
    from reporting_grain
    left join app 
        on reporting_grain.app_id = app.app_id
    left join app_store_territory 
        on reporting_grain.date_day = app_store_territory.date_day
        and reporting_grain.app_id = app_store_territory.app_id 
        and reporting_grain.source_type = app_store_territory.source_type
        and reporting_grain.territory = app_store_territory.territory
    left join downloads_territory_filled
        on reporting_grain.date_day = downloads_territory_filled.date_day
        and reporting_grain.app_id = downloads_territory_filled.app_id 
        and reporting_grain.source_type = downloads_territory_filled.source_type
        and reporting_grain.territory = downloads_territory_filled.territory
    left join country_codes as official_country_codes
        on reporting_grain.territory = official_country_codes.country_name
    left join country_codes as alternative_country_codes
        on reporting_grain.territory = alternative_country_codes.alternative_country_name
)

select * 
from joined