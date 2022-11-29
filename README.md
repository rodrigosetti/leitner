# leitner

Web application that implements the [Leitner system](https://en.wikipedia.org/wiki/Leitner_system) for flashcards.

## Dependencies

 * Haskell and Sqlite3

## Setup

1. Create the database:

```shell
sqlite3 questions.db < schema.sql
```

2. Populate the questions in the schema:

```shell
sqlite3 questions.db
sqlite> insert into questions values (...);
```

3. Start the webserver and [open the browser](http://localhost:8080/)

```
cabal run
```
