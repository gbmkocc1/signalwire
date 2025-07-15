# Monitoring Guide

This guide will help you access and use the monitoring setup with Prometheus and Grafana.

## Accessing Grafana

1. Open your browser and navigate to http://localhost:3001
2. Login with the following credentials:
   - Username: `admin`
   - Password: `admin`
3. You'll be prompted to change the password on first login (optional)

## Available Dashboards

The following dashboards are pre-configured:

### System Overview Dashboard

This dashboard provides basic system metrics:
- Prometheus HTTP request rates
- Number of targets being monitored
- Scrape durations for different targets

### Redis Dashboard

This dashboard provides Redis-specific metrics:
- Connected clients
- Memory usage
- Command processing rate

## Adding Custom Dashboards

You can create custom dashboards in Grafana by:

1. Click the "+" icon in the left sidebar
2. Select "Dashboard"
3. Click "Add new panel"
4. Select Prometheus as the data source
5. Write PromQL queries to visualize your metrics

## Common PromQL Queries

Here are some useful PromQL queries for monitoring:

### Redis Metrics

- Redis memory usage: `redis_memory_used_bytes`
- Redis connected clients: `redis_connected_clients`
- Redis command rate: `rate(redis_commands_processed_total[5m])`
- Redis hit ratio: `redis_keyspace_hits_total / (redis_keyspace_hits_total + redis_keyspace_misses_total)`

### Prometheus Metrics

- Prometheus targets: `prometheus_sd_discovered_targets`
- Prometheus scrape duration: `rate(prometheus_target_scrape_pool_duration_seconds_sum[5m])`
- Prometheus HTTP requests: `rate(prometheus_http_requests_total[5m])`

## Troubleshooting

If metrics are not showing up:

1. Check if the services are running: `docker-compose ps`
2. Check if Prometheus can reach the targets: http://localhost:9090/targets
3. Check the logs for any errors: `docker-compose logs prometheus`
4. Check the logs for the exporters: `docker-compose logs redis-exporter`

## Adding Rails Application Metrics

To add metrics to your Rails application:

1. Add the Prometheus client gem to your Gemfile:
   ```ruby
   gem 'prometheus-client'
   ```

2. Create an initializer in `config/initializers/prometheus.rb`:
   ```ruby
   require 'prometheus/client'
   require 'prometheus/client/middleware'

   # Create a metrics registry
   prometheus = Prometheus::Client.registry

   # Define metrics
   http_requests_total = Prometheus::Client::Counter.new(:http_requests_total, 'Total HTTP requests')
   http_request_duration_seconds = Prometheus::Client::Histogram.new(:http_request_duration_seconds, 'HTTP request duration')
   
   # Register metrics
   prometheus.register(http_requests_total)
   prometheus.register(http_request_duration_seconds)

   # Add middleware to expose metrics
   Rails.application.middleware.use Prometheus::Client::Middleware::Exporter
   ```

3. Instrument your code:
   ```ruby
   # In your controller
   http_requests_total.increment(path: request.path, method: request.method)
   ``` 