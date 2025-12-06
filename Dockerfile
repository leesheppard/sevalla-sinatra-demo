FROM ruby:3.2-alpine

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    postgresql-client \
    postgresql-dev \
    git

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --jobs 4 --retry 3 && \
    rm -rf /usr/local/bundle/cache/*

# Copy application code
COPY . .

# Create exports directory
RUN mkdir -p exports

# Make start script executable
RUN chmod +x bin/start.sh

# Expose port
EXPOSE 3000

# Default command
CMD ["bin/start.sh"]