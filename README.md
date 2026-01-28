# PostgreSQL 18 with pg_partman

Docker image of PostgreSQL 18 with [pg_partman](https://github.com/pgpartman/pg_partman) extension pre-installed for automatic table partitioning.

## Features

- PostgreSQL 18.1 (Debian Bookworm)
- pg_partman pre-installed
- Multi-architecture support (amd64, arm64)
- Production ready

## Usage

### Pull the image

```bash
docker pull ghcr.io/davispalomino/postgresql-partman:latest
```

### Run the container

```bash
docker run -d \
  --name postgres \
  -e POSTGRES_PASSWORD=your_secure_password \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_DB=my_database \
  -p 5432:5432 \
  -v postgres_data:/var/lib/postgresql/data \
  ghcr.io/davispalomino/postgresql-partman:latest
```

### Docker Compose

```yaml
services:
  postgres:
    image: ghcr.io/davispalomino/postgresql-partman:latest
    container_name: postgres
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: your_secure_password
      POSTGRES_DB: my_database
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
```

## Enable pg_partman

Once connected to PostgreSQL, enable the extension:

```sql
-- Create schema for pg_partman (optional but recommended)
CREATE SCHEMA IF NOT EXISTS partman;

-- Create the extension
CREATE EXTENSION pg_partman SCHEMA partman;

-- Verify installation
SELECT * FROM pg_extension WHERE extname = 'pg_partman';
```

## Partitioning Example

```sql
-- Create a table partitioned by date
CREATE TABLE events (
    id BIGSERIAL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    type VARCHAR(50),
    data JSONB
) PARTITION BY RANGE (created_at);

-- Configure automatic monthly partitioning
SELECT partman.create_parent(
    p_parent_table := 'public.events',
    p_control := 'created_at',
    p_interval := '1 month',
    p_premake := 3
);

-- Run maintenance (add to cron)
SELECT partman.run_maintenance();
```

## Available Tags

| Tag | Description |
|-----|-------------|
| `latest` | Latest stable version |
| `main` | Build from main branch |
| `vX.Y.Z` | Specific version |
| `vX.Y` | Latest patch of minor version |
| `vX` | Latest version of major |
| `sha-XXXXXX` | Specific commit build |

## Environment Variables

All variables from the [official PostgreSQL image](https://hub.docker.com/_/postgres) are available:

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_PASSWORD` | Superuser password (required) | - |
| `POSTGRES_USER` | Superuser name | `postgres` |
| `POSTGRES_DB` | Initial database | `$POSTGRES_USER` |
| `PGDATA` | Data directory | `/var/lib/postgresql/data` |

## Build Locally

```bash
# Clone the repository
git clone https://github.com/davispalomino/postgresql-partman.git
cd postgresql-partman

# Build the image
docker build -t postgresql-partman .

# Run
docker run -d -e POSTGRES_PASSWORD=test -p 5432:5432 postgresql-partman
```

## CI/CD

This repository uses GitHub Actions for:

- Automatic build on every push to `main`
- Multi-architecture build (amd64, arm64)
- Automatic push to GitHub Container Registry
- Semantic versioning with tags
- Layer caching for fast builds
- Build provenance attestation (SLSA)

## License

This project is under the MIT license. PostgreSQL and pg_partman have their own licenses.

## Links

- [PostgreSQL](https://www.postgresql.org/)
- [pg_partman](https://github.com/pgpartman/pg_partman)
- [pg_partman Documentation](https://github.com/pgpartman/pg_partman/blob/master/doc/pg_partman.md)
