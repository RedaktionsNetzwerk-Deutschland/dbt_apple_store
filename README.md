<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_apple_store/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="Fivetran-Release"
        href="https://fivetran.com/docs/getting-started/core-concepts#releasephases">
        <img src="https://img.shields.io/badge/Fivetran Release Phase-_Beta-orange.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_core-version_>=1.0.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Apple App Store dbt Package ([Docs](https://fivetran.github.io/dbt_apple_store/))
# 📣 What does this dbt package do?
- Produces modeled tables that leverage Apple App Store data from [Fivetran's connector](https://fivetran.com/docs/applications/apple-app-store) in the format described by [this ERD](https://docs.google.com/presentation/d/1zeV9F1yakOQbgx-L0xQ7h8I3KRuJL_tKc7srX_ctaYw/edit?usp=sharing) and builds off the output of our [Apple App Store source package](https://github.com/fivetran/dbt_apple_store_source).
- The above mentioned models enable you to better understand your Apple App Store metrics at different granularities. It achieves this by:
  - Providing intuitive reporting at the App Version, Platform Version, Device, Source Type, Territory, Subscription and Overview levels
  - Aggregates all relevant application metrics into each of the reporting levels above
- Generates a comprehensive data dictionary of your source and modeled Apple App Store data via the [dbt docs site](https://fivetran.github.io/dbt_apple_store/)

Refer to the table below for a detailed view of all models materialized by default within this package. Additionally, check out our [Docs site](https://fivetran.github.io/dbt_apple_store/#!/overview?g_v=1) for more details about these models. 

| **model**                  | **description**                                                                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [apple_store__app_version_report](https://github.com/fivetran/dbt_apple_store/blob/main/models/apple_store__app_version_report.sql)             | Each record represents daily metrics for each by app_id, source_type and app version. |
| [apple_store__device_report](https://github.com/fivetran/dbt_apple_store/blob/main/models/apple_store__device_report.sql)     | Each record represents daily subscription metrics by app_id, source_type and device. |
| [apple_store__overview_report](https://github.com/fivetran/dbt_apple_store/blob/main/models/apple_store__overview_report.sql)     | Each record represents daily metrics for each app_id. |
| [apple_store__platform_version_report](https://github.com/fivetran/dbt_apple_store/blob/main/models/apple_store__platform_version_report.sql)    | Each record represents daily metrics for each by app_id, source_type and platform version. |
| [apple_store__source_type_report](https://github.com/fivetran/dbt_apple_store/blob/main/models/apple_store__source_type_report.sql)   | Each record represents daily metrics by app_id and source_type. |
| [apple_store__subscription_report](https://github.com/fivetran/dbt_apple_store/blob/main/models/apple_store__subscription_report.sql) | Each record represents daily subscription metrics by account, app, subscription name, country and state. |
| [apple_store__territory_report](https://github.com/fivetran/dbt_apple_store/blob/main/models/apple_store__territory_report.sql) | Each record represents daily subscription metrics by app_id, source_type and territory. |
# 🤔 Who is the target user of this dbt package?
- You use Fivetran's [GitHub connector](https://fivetran.com/docs/applications/Github)
- You use dbt
- You want a staging layer that cleans, tests, and prepares your GitHub data for analysis as well as leverage the analysis ready models outlined above.

# 🎯 How do I use the dbt package?
To effectively install this package and leverage the pre-made models, you will follow the below steps:
## Step 1: Pre-Requisites
You will need to ensure you have the following before leveraging the dbt package.
- **Connector**: Have the Fivetran GitHub connector syncing data into your warehouse. 
- **Database support**: This package has been tested on **BigQuery**, **Snowflake**, **Redshift**, and **Postgres**. Ensure you are using one of these supported databases.
- **dbt Version**: This dbt package requires you have a functional dbt project that utilizes a dbt version within the respective range `>=1.0.0, <2.0.0`.

## Step 2: Installing the Package
Include the following github package version in your `packages.yml`
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/apple_store
    version: [">=0.1.0", "<0.2.0"]
```
**On your first run,** please be sure to do a `dbt build` to ensure that all dependencies for this package are properly loaded. 

## Step 3: Configure Your Variables
### Database and Schema Variables
By default, this package will run using your target database, the `itunes_connect` schema and the default Fivetran Source Tables names for Apple App Store listed above. If this is not where your Apple App Store data is (perhaps your Apple App Store schema is `itunes_connect_fivetran` your `app` table is named `usa_app`), add the following configuration to your `dbt_project.yml` file:

```yml
vars:
  apple_store_source:
    apple_store_database: your_database_name
    apple_store_schema: your_schema_name 
    <default_source_table_name>_identifier: your_table_name
```
### Enabling Components
Your Apple App Store connector might not sync every table that this package expects. If you use subscriptions and have the `sales_subscription_event_summary` and `sales_subscription_summary` tables synced, add the following variable to your `dbt_project.yml` file:

```yml
vars:
  apple_store__using_subscriptions: true # by default this is assumed to be false
```

Additionally, by default, `Subscribe`, `Renew` and `Cancel` subscription events are included and required in this package for downstream usage. If you would like to add additional subscription events, please add the below to your `dbt_project.yml`:

```yml
    apple_store__subscription_events:
    - 'Renew'
    - 'Cancel'
    - 'Subscribe'
    - '<additional_event_name>'
    - '<additional_event_name>'
```
## (Optional) Step 4: Additional Configurations
### Change the Build Schema
By default, this package builds the Apple App Store staging models within a schema titled (<target_schema> + `_apple_store_source`) and your Apple App Store modeling models within a schema titled (<target_schema> + `_apple_store`) in your target database. If this is not where you would like your Apple App Store staging data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    apple_store_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
    apple_store:
      +schema: my_new_schema_name # leave blank for just the target_schema
```

## Step 5: Finish Setup
Your dbt project is now setup to successfully run the dbt package models! You can now execute `dbt run` and `dbt test` to have the models materialize in your warehouse and execute the data integrity tests applied within the package.

## (Optional) Step 6: Orchestrate your package models with Fivetran
Fivetran offers the ability for you to orchestrate your dbt project through the [Fivetran Transformations for dbt Core](https://fivetran.com/docs/transformations/dbt) product. Refer to the linked docs for more information on how to setup your project for orchestration through Fivetran. 

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. For more information on the below packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> **If you have any of these dependent packages in your own `packages.yml` I highly recommend you remove them to ensure there are no package version conflicts.**
```yml
packages:
    - package: fivetran/apple_store_source
      version: [">=0.1.0", "<0.2.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.3.0", "<0.4.0"]

    - package: dbt-labs/dbt_utils
      version: [">=0.8.0", "<0.9.0"]
```
# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package **only** maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/github/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_apple_store/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
These dbt packages are developed by a small team of analytics engineers at Fivetran. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package!

# 🏪 Are there any resources available?
- If you encounter any questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_apple_store/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran, or would like to request a future dbt package to be developed, then feel free to fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to just say hi? Book a time during our office hours [here](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or send us an email at solutions@fivetran.com.
