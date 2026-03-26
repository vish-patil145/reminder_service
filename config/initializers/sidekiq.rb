# config/initializers/sidekiq.rb
require "sidekiq/web"

Rails.application.config.active_job.queue_adapter = :sidekiq
