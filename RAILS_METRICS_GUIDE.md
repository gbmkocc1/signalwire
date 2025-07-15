# Rails Application Metrics Guide

This guide explains how the Rails application metrics are implemented and how they are visualized in Grafana.

## Implementation Overview

We've implemented a simplified metrics approach for demonstration purposes:

1. **Metrics Endpoint**: The Rails application exposes a `/metrics` endpoint that returns metrics in Prometheus format.

2. **Static Metrics**: For simplicity, we're returning static metrics data instead of actual runtime metrics.

3. **Prometheus Integration**: Prometheus is configured to scrape metrics from the Rails application every 5 seconds.

4. **Grafana Dashboards**: A pre-configured dashboard visualizes these metrics.

## Metrics Exposed

The following metrics are exposed by the Rails application:

1. **hello_world_views_total**: A counter tracking how many times the Hello World page has been viewed.

2. **http_requests_total**: A counter tracking the total number of HTTP requests, labeled by path.

3. **http_request_duration_seconds**: A histogram tracking the duration of HTTP requests.

## Accessing the Metrics

You can access the metrics directly at:

```
http://localhost:3000/metrics
```

Prometheus scrapes these metrics and makes them available for querying at:

```
http://localhost:9090/graph
```

## Grafana Dashboard

A pre-configured Grafana dashboard is available at:

```
http://localhost:3001/d/rails-application/rails-application
```

Login credentials:
- Username: `admin`
- Password: `admin`

The dashboard includes the following panels:

1. **HTTP Request Rate**: Shows the rate of HTTP requests over time.
2. **Hello World Views**: Shows the rate of views to the Hello World page.
3. **HTTP Request Duration**: Shows the 95th and 50th percentile of HTTP request durations.
4. **Database Query Duration**: Shows the 95th and 50th percentile of database query durations.
5. **Ruby GC Statistics**: Shows garbage collection statistics.

## Implementing Real Metrics

To implement real metrics instead of static ones, you would:

1. Add the Prometheus client gem to your Gemfile:
   ```ruby
   gem 'prometheus-client'
   ```

2. Create a proper initializer in `config/initializers/prometheus.rb`:
   ```ruby
   require 'prometheus/client'
   require 'prometheus/client/middleware'

   # Create a metrics registry
   prometheus = Prometheus::Client.registry

   # Define metrics
   http_requests_total = Prometheus::Client::Counter.new(
     :http_requests_total,
     docstring: 'Total HTTP requests'
   )
   
   # Register metrics
   prometheus.register(http_requests_total)

   # Add middleware to expose metrics
   Rails.application.middleware.use Prometheus::Client::Middleware::Exporter
   ```

3. Instrument your code:
   ```ruby
   # In your controller
   http_requests_total.increment(labels: { path: request.path })
   ```

## Troubleshooting

If metrics are not showing up in Grafana:

1. Check if the Rails application is running: `docker-compose ps web`
2. Check if the metrics endpoint is accessible: `curl http://localhost:3000/metrics`
3. Check if Prometheus is scraping the metrics: `curl http://localhost:9090/api/v1/targets`
4. Check if Grafana can query Prometheus: Visit the Explore page in Grafana and try querying `hello_world_views_total` 