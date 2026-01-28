FROM postgres:18.1-bookworm

LABEL org.opencontainers.image.title="PostgreSQL with pg_partman"
LABEL org.opencontainers.image.description="PostgreSQL 18 with pg_partman extension for automatic table partitioning"
LABEL org.opencontainers.image.vendor="Custom Build"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/davispalomino/postgresql-partman"
LABEL org.opencontainers.image.documentation="https://github.com/davispalomino/postgresql-partman#readme"

# Install pg_partman
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends postgresql-18-partman; \
    rm -rf /var/lib/apt/lists/*
