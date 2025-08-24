# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Application Overview

This is a Rails 8.0.2 application called "quintas-futebol" (football/soccer Thursdays) that implements a multi-tenant system with account-based user management. The app uses modern Rails stack including Hotwire, Tailwind CSS, and Solid Suite (SolidCache, SolidQueue, SolidCable).

### Key Architectural Patterns

- **Multi-tenancy**: Account-based system where users can belong to multiple accounts via `account_users` join table
- **Authentication**: Custom session-based authentication with secure password handling via `bcrypt`
- **Current Context**: Uses `Current` model pattern for thread-local account/user context
- **Modern Rails Stack**: Rails 8 with Solid Suite for background jobs, caching, and WebSocket connections
- **Hybrid Database**: PostgreSQL for primary data, SQLite for cache/queue/cable storage

## Development Commands

### Setup & Environment
```bash
# Install dependencies and setup database
bin/setup

# Start development server with all services (web, jobs, CSS watcher)
bin/dev

# Start individual services
bin/rails server  # Web server only
bin/jobs          # Background job processor
bin/rails tailwindcss:watch  # CSS file watcher
```

### Database Operations
```bash
# Database setup and migrations
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed

# Reset database
bin/rails db:drop db:create db:migrate db:seed

# Database console
bin/rails dbconsole
```

### Testing
```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb

# Run tests with coverage check
bin/check_coverage.sh

# Run tests matching pattern
bundle exec rspec --grep "user authentication"
```

### Code Quality & Linting
```bash
# Run RuboCop linter
bin/rubocop

# Auto-fix RuboCop violations
bin/rubocop -A

# Run security scanner
bin/brakeman

# Check current test coverage threshold
cat coverage_threshold.txt
```

### Background Jobs & Monitoring
```bash
# Access job monitoring interface at /jobs
# (Mission Control Jobs interface)

# Run job worker in development
bin/jobs

# Rails console for job debugging
bin/rails console
```

### Deployment (Kamal)
```bash
# Deploy to production
kamal deploy

# Deploy with specific image
kamal app deploy

# Access production console
kamal console

# Check logs
kamal logs

# SSH into production server
kamal shell
```

## Database Architecture

### Multi-Database Setup
- **Primary**: PostgreSQL for application data (users, accounts, business logic)
- **Cache**: SQLite for Rails cache storage
- **Queue**: SQLite for Solid Queue background jobs
- **Cable**: SQLite for Action Cable WebSocket connections

### Key Models & Relations
```ruby
# Account system - multi-tenancy
Account
├── has_many :account_users
├── has_many :users, through: :account_users
└── slug-based routing (/accounts/:slug/set)

User
├── has_many :account_users
├── has_many :accounts, through: :account_users
├── has_many :sessions
└── has_secure_password (bcrypt)

# Context management
Current
├── attribute :account
├── attribute :user
└── Thread-local storage for request context
```

### Authentication Flow
- Custom session-based authentication (not Devise)
- Multi-account user switching via `accounts_controller#set`
- Password reset functionality via email tokens
- Session management with database-backed sessions

## Development Database Setup

The application expects PostgreSQL running on:
- Host: localhost
- Port: 55000
- Username: postgres  
- Password: postgrespw
- Development DB: quintas_futebol_development
- Test DB: quintas_futebol_test

## Key Configuration Files

- `Procfile.dev`: Defines development processes (web, jobs, CSS)
- `config/deploy.yml`: Kamal deployment configuration
- `config/database.yml`: Multi-database configuration
- `.rubocop.yml`: Uses rails-omakase styling
- `coverage_threshold.txt`: Minimum test coverage requirement (45.96%)

## Testing Strategy

- **Framework**: RSpec with FactoryBot for test data
- **Coverage**: SimpleCov with enforced minimum threshold via `bin/check_coverage.sh`
- **Matchers**: Shoulda matchers for Rails-specific assertions
- **Database**: DatabaseCleaner for test isolation

## Important Development Notes

- Uses Rails 8 defaults including error reporting and health checks
- Tailwind CSS v3.3.1 (not v4) due to Docker/ARM64 build issues
- Background jobs run in Puma process in development (SOLID_QUEUE_IN_PUMA=true)
- Mission Control Jobs mounted at `/jobs` for job monitoring
- Account selection UI available at `/accounts/select`
