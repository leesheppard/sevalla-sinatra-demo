#!/bin/sh
set -e

# Prepare database (create tables if needed)
bundle exec rake db:migrate

# Start Sidekiq worker in the background
bundle exec sidekiq -r ./app.rb -c 5 -e ${RACK_ENV:-production} &
SIDEKIQ_PID=$!

# Start the web server
bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-production}

# Keep Sidekiq running if the web server exits
wait $SIDEKIQ_PID
