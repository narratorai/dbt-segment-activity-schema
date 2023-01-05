

# Segment - Activity Schema

This packages builds activity stream tables for Segment page views. To learn more about the activity schema visit the [home page](https://www.activityschema.com)

> This package is built and supported by [Narrator](https://www.narratordata.com), which provides a full end-to-end activity schema implementation.

## Installation

Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include this in your `packages.yml`

```yaml
packages:
  - package: narratorai/segment_activity_schema
    version: [">=0.1.0", "<0.2.0"]
```


## Configuration

By default this runs using the `segment` schema. If your Segment data is in another schema you can specify it in your `dbt_project.yml` file

```yml
vars:
    segment_schema: your_schema_name
```

### Activities

**viewed_page**
Table name: `activity_stream_viewed_page__segment`

**started_session**
Table name: `activity_stream_started_session__segment`


## Contributions
We welcome any contributions to this package! Testing is always appreciated -- if this doesn't run on your warehouse / your environment please create an issue. 

If you'd like to contribute code please fork and create a PR. [This post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) has some helpful tips on contributing to a package.