with app as (

    select * 
    from {{ var('app') }}
),

crashes_app_version_report as (
    
    select *
    from {{ ref('int_apple_store__crashes_app_version') }}
),

reporting_grain_combined as (
    select 
        date_day,
        app_id,
        source_type,
        app_version
    from crashes_app_version_report
),

reporting_grain as (

    select 
        distinct *
    from reporting_grain_combined
),

joined as (

    select 
        reporting_grain.date_day,
        reporting_grain.app_id, 
        app.app_name,
        reporting_grain.source_type,
        reporting_grain.app_version,
        coalesce(crashes_app_version_report.crashes, 0) as crashes,
        0 as active_devices,
        0 as active_devices_last_30_days,
        0 as deletions,
        0 as installations,
        0 as sessions
    from reporting_grain
    left join app 
        on reporting_grain.app_id = app.app_id
    left join crashes_app_version_report
        on reporting_grain.date_day = crashes_app_version_report.date_day
        and reporting_grain.app_id = crashes_app_version_report.app_id
        and reporting_grain.source_type = crashes_app_version_report.source_type
        and reporting_grain.app_version = crashes_app_version_report.app_version
)

select * 
from joined