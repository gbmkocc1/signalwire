# Rails App with Monitoring Stack

This project contains a simple Rails "Hello World" application with a complete monitoring stack using Docker Compose.

## Components

- **Rails App**: Simple "Hello World" application (port 3000)
- **PostgreSQL**: Database for the Rails application (port 5432)
- **Redis**: In-memory data store (port 6379)
- **Prometheus**: Metrics collection and storage (port 9090)
- **Grafana**: Visualization and dashboards (port 3001)

## Getting Started

### Starting the Stack

```bash
docker-compose up -d
```

### Accessing the Services

- Rails App: http://localhost:3000
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3001 (login with admin/admin)

## Monitoring Setup

### Prometheus

Prometheus is configured to scrape metrics from:
- Itself (localhost:9090)
- Rails application (web:3000/metrics)
- Redis (redis:6379)

The Prometheus configuration is located in `prometheus/prometheus.yml`.

### Grafana

Grafana is pre-configured with:
- Admin user: admin
- Admin password: admin
- Prometheus data source (automatically connected)

## Adding More Monitoring

To add more metrics to the Rails application, you can:

1. Add the Prometheus client gem to your Rails app
2. Instrument your code with metrics
3. Expose a /metrics endpoint

## Shutting Down

To stop all services:

```bash
docker-compose down
```

To stop all services and remove volumes:

```bash
docker-compose down -v
```

