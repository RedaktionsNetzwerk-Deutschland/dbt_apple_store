# dbt_apple_store v0.2.0

## 🚨 Breaking Changes 🚨:
[PR #6](https://github.com/fivetran/dbt_apple_store/pull/6) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `packages.yml` has been updated to reflect new default `fivetran/fivetran_utils` version, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_apple_store v0.1.0

## Initial Release
This is the initial release of this package. 

__What does this dbt package do?__
- Produces modeled tables that leverage Apple App Store data from [Fivetran's connector](https://fivetran.com/docs/applications/apple-app-store) in the format described by [this ERD](https://docs.google.com/presentation/d/1zeV9F1yakOQbgx-L0xQ7h8I3KRuJL_tKc7srX_ctaYw/edit?usp=sharing) and builds off the output of our [Apple App Store source package](https://github.com/fivetran/dbt_apple_store_source).
- The above mentioned models enable you to better understand your Apple App Store metrics at different granularities. It achieves this by:
  - Providing intuitive reporting at the App Version, Platform Version, Device, Source Type, Territory, Subscription and Overview levels
  - Aggregates all relevant application metrics into each of the reporting levels above
- Generates a comprehensive data dictionary of your source and modeled Apple App Store data via the [dbt docs site](https://fivetran.github.io/dbt_apple_store/)

For more information refer to the [README](/README.md).