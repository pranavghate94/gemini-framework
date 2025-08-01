# Trait Records

The `trait_records` table stores individual data records for traits, designed for columnar storage.

## Table Schema

| Column Name       | Data Type   | Description                                                                                      |
| ----------------- | ----------- | ------------------------------------------------------------------------------------------------ |
| `id`              | `UUID`      | **Primary Key.** Unique identifier for the trait record.                                         |
| `timestamp`       | `TIMESTAMP` | Timestamp of the record.                                                                         |
| `trait_id`        | `UUID`      | Foreign key referencing the trait.                                                               |
| `trait_name`      | `String(255)` | The name of the trait.                                                                           |
| `trait_units`     | `String(255)` | The units in which the trait is measured.                                                        |
| `trait_level_id`  | `Integer`   | Foreign key referencing the trait level.                                                         |
| `trait_level_name`| `String(255)` | The name of the trait level.                                                                     |
| `trait_data`      | `JSONB`     | Additional JSONB data for the trait.                                                             |
| `experiment_id`   | `UUID`      | Foreign key referencing the experiment.                                                          |
| `experiment_name` | `String(255)` | The name of the experiment.                                                                      |
| `season_id`       | `UUID`      | Foreign key referencing the season.                                                              |
| `season_name`     | `String(255)` | The name of the season.                                                                          |
| `site_id`         | `UUID`      | Foreign key referencing the site.                                                                |
| `site_name`       | `String(255)` | The name of the site.                                                                            |
| `record_file`     | `String(255)` | The file where the record is stored.                                                             |
| `record_info`     | `JSONB`     | Additional JSONB data for the record.                                                            |

## Constraints and Indexes

- **Unique Constraint:** A `UniqueConstraint` on `timestamp`, `trait_id`, `trait_name`, `trait_units`, `trait_level_id`, `trait_level_name`, `experiment_id`, `experiment_name`, `season_id`, `season_name`, `site_id`, and `site_name` ensures uniqueness for each record.
- **GIN Index:** A GIN index named `idx_trait_records_record_info` is applied to the `record_info` column to optimize queries on the JSONB data.

## Methods

- **`filter_records`**: A class method that allows filtering trait records based on various parameters such as `start_timestamp`, `end_timestamp`, `trait_names`, `trait_level_names`, `experiment_names`, `season_names`, and `site_names`. This method leverages a PostgreSQL function `gemini.filter_trait_records` for efficient filtering.
