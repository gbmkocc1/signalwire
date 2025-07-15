FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock* ./

# Install gems
RUN bundle install

# Copy application files
COPY . .

# Make the entrypoint script executable
RUN chmod +x /app/bin/rails
RUN chmod +x /app/entrypoint.sh

# Expose port 3000
EXPOSE 3000

# Set the entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"] 