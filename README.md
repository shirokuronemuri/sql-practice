# sql-practice

repository where I am writing some sql by hand to actually **REMEMBER** it.

## Setup

to run the queries, first create the db and run the script that creates all tables and applies seed files:

```bash
$ psql -c "CREATE DATABASE sql_practice;"
$ psql -d sql_practice -f repopulate.sql
```

This script drops the schema before applying everything else so you can run it whenever you need to reset all data to default state.
