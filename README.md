# Naisho

Naisho is a free and open-source tool for sending personal information data deletion request emails to data brokers via SMTP.

## Stack

- [Ruby on Rails](https://rubyonrails.org/)
- [Hotwire](https://hotwired.dev/)
- [SQLite3](https://www.sqlite.org/index.html)
- [ViewComponent](https://viewcomponent.org/)

## Local setup (native)

1. Clone the repo.
2. Install [Ruby](https://www.ruby-lang.org/en/) v3.3.6.
3. Install [SQLite3](https://www.sqlite.org/index.html).
4. Run `bin/setup` to install Ruby dependencies and set up the database.
5. Run `bin/rake sync_companies` to pull the latest data broker companies from sources.
6. Run `bin/rails server` to start the Rails server.
