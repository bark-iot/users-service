# users-service

See `bark` repository for instructions.

# API docs
- to view go to [http://localhost/users/docs](http://localhost/users/docs)
- to build run `cd docs && mkdocs build`

# Migrations
- `docker-compose run users-service ./cli db_migrate`

# Run tests
- `dc run users-service rspec`