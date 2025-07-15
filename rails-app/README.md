# Rails Hello World Docker App

A simple Rails application that displays "Hello World" when run.

## Running with Docker Compose

To build and start the application:

```bash
cd aws-rails-montitoring
docker-compose up --build
```

Or to run in detached mode:

```bash
docker-compose up -d --build
```

Once the application is running, you can access it at:

http://localhost:3000

## Project Structure

- `app/controllers/hello_controller.rb` - Contains the hello controller
- `app/views/hello/index.html.erb` - Contains the hello world view
- `config/routes.rb` - Defines the root route to the hello controller
- `Dockerfile` - Instructions for building the Docker image
- `docker-compose.yml` - Configuration for running the application with Docker Compose and PostgreSQL

## Database

This application uses PostgreSQL as the database, which is automatically set up by Docker Compose.