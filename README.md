# Flagme

A Phoenix/Elixir API service for managing feature flags with caching.

Flagme provides a REST API to create, retrieve, and update feature flags. Each flag supports both on/off status and percentage-based enablement for gradual rollouts. Flags are persisted in PostgreSQL and cached in-memory using a GenServer backed by ETS with configurable TTL.

## API Endpoints

- `POST /api/v1/flags` — Create a new flag
- `GET /api/v1/flags/:name` — Retrieve a flag by name (cache-first)
- `PATCH /api/v1/flags/:id` — Update flag status/percentage

## Flag Fields

| Field          | Description                        |
|----------------|------------------------------------|
| `name`         | Unique identifier for the flag     |
| `enabled`      | Boolean on/off status              |
| `enabled_perc` | Rollout percentage (0–100)         |
| `inserted_by`  | Metadata about who created it      |