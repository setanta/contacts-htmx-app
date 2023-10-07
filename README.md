# Contacts.app

A Crystal port of the demo Contacts application from the [HTMX book](https://hypermedia.systems/book/contents/).
It uses [Kemal](https://kemalcr.com/) for the webserver part,
[ECR templates](https://crystal-lang.org/api/ECR.html) for producing the HTML,
and [Granite](https://docs.amberframework.org/granite/) (with [SQLite](https://sqlite.org/index.html))
for the database part.

## Set It Up

```bash
$ shards install
$ DATABASE_URL='sqlite3://./contacts.sqlite' ./bin/micrate up
```

## Run It

```bash
$ crystal run src/app.cr
```
