class HelloController < ApplicationController
  def index
    # Increment the hello world views counter
    if defined?(MetricsController.class_variable_get(:@@hello_world_views))
      MetricsController.class_variable_set(:@@hello_world_views, MetricsController.class_variable_get(:@@hello_world_views) + 1)
    end
    
    # Increment the root path requests counter
    if defined?(MetricsController.class_variable_get(:@@http_requests_root))
      MetricsController.class_variable_set(:@@http_requests_root, MetricsController.class_variable_get(:@@http_requests_root) + 1)
    end
  end
end 