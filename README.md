# Sinatra / Sidekiq Example

This is a simple example of how to use Sidekiq to export CSV files in the background.

### Prerequisites

- Ruby 3.4.4
- PostgreSQL 16
- Sidekiq 6.5.7

### Development Setup

1. Install dependencies:
```bash
bundle install
```

2. Set up the database:
```bash
createdb sinatra_exports_dev
```

3. Run the seed:
```bash
rake seed
```

4. Start Sidekiq:
```bash
bundle exec sidekiq
```

5. Start the Sinatra app:
```bash
bundle exec rackup
```

### Directory structure

```
.
├── Gemfile                  # Ruby dependencies
├── Gemfile.lock             # Locked gem versions (generated after bundle install)
├── Rakefile                 # Rake tasks (includes seed task)
├── config.ru                # Rack configuration
├── app.rb                   # Main Sinatra application and routes
├── config/
│   ├── database.rb          # Database configuration
│   └── sidekiq.rb           # Sidekiq configuration
├── models/
│   ├── user.rb              # User model
│   └── order.rb             # Order model
├── workers/
│   └── export_worker.rb     # Background job for CSV exports
├── views/
│   └── index.erb            # HTML template
├── exports/                 # Generated CSV files (created automatically)
└── db/                      # Database files (PostgreSQL doesn't use this)
    └── (not used with PostgreSQL)
```

## Docker

### Build and start all services

```bash
docker-compose up --build
```

### Run database setup (first time only)

```bash
docker-compose exec web rake db:create
docker-compose exec web rake seed
```