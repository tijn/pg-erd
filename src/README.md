# Postgres ERD

## Generate Entity-Relationship Diagrams for Postgresql Databases

Postgres ERD is a program that allows you to easily generate a diagram based on a postgresql database schema. The diagram gives an overview of how your tables are related. Having a diagram to describes your tables is perfect for documentation.

Postgres ERD is heavily inspired by [Rails ERD](https://voormedia.github.io/rails-erd/) but it serves some different use cases. First and foremost it does not rely on Rails (like Rails ERD). Thus you can use it for any database schema regardless of your project's language.

## An Example


# Requirements

- Ruby 2.4+
- postgresql

# Getting started

[It's part of a two-step program](https://www.youtube.com/watch?v=_c1NJQ0UP_Q):

Install the gem

```sh
gem install pg-erd
```

Use the thing:

```sh
pg-erd {{the-name-of-your-database}}
```

This will output a diagram of your database in [dot format](http://www.graphviz.org/). You can save it 

```sh
pg-erd {{the-name-of-your-database}} > my-awesome-database.dot
```

... or run it though graphviz to create a png file:

```sh
pg-erd {{the-name-of-your-database}} | dot -Tpng > erd.png
```

... which you may also do like this: 

```sh
pg-erd --title "Secret Project X" --format png {{the-name-of-your-database}} > erd.png
```

There are many more formats and a few more useful options. You can find them all with `--help`

# Free extras

## pg-erd-everything

This command will create an ERD for every database on your system. It will write many image files, one for each database, to the current directory.

## pg-list-databases

Like `ls` but it lists the names of your postgres databases one by one.

## pg-inspect

This command outputs a summary of your database structure to the console. It shows the same information as an ERD but then in plain text.

