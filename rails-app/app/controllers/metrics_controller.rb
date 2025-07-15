class MetricsController < ApplicationController
  # Class variables to track metrics between requests
  @@hello_world_views = 42
  @@http_requests_root = 100
  @@http_requests_metrics = 10
  @@request_durations = {
    "0.01" => 10,
    "0.1" => 20,
    "0.5" => 30,
    "1" => 40,
    "+Inf" => 50
  }
  @@request_duration_sum = 12.34
  @@request_duration_count = 50

  def index
    # Increment metrics for demonstration
    @@http_requests_metrics += 1
    
    # Return metrics with updated values
    metrics = <<~METRICS
      # HELP hello_world_views_total Number of times the Hello World page has been viewed
      # TYPE hello_world_views_total counter
      hello_world_views_total #{@@hello_world_views}
      
      # HELP http_requests_total Total number of HTTP requests
      # TYPE http_requests_total counter
      http_requests_total{path="/"} #{@@http_requests_root}
      http_requests_total{path="/metrics"} #{@@http_requests_metrics}
      
      # HELP http_request_duration_seconds HTTP request duration in seconds
      # TYPE http_request_duration_seconds histogram
      http_request_duration_seconds_bucket{le="0.01"} #{@@request_durations["0.01"]}
      http_request_duration_seconds_bucket{le="0.1"} #{@@request_durations["0.1"]}
      http_request_duration_seconds_bucket{le="0.5"} #{@@request_durations["0.5"]}
      http_request_duration_seconds_bucket{le="1"} #{@@request_durations["1"]}
      http_request_duration_seconds_bucket{le="+Inf"} #{@@request_durations["+Inf"]}
      http_request_duration_seconds_sum #{@@request_duration_sum}
      http_request_duration_seconds_count #{@@request_duration_count}
    METRICS
    
    render plain: metrics
  end
end 