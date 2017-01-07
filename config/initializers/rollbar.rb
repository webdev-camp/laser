Rollbar.configure do |config|
  # Without configuration, Rollbar is enabled in all environments.
  # To disable in specific environments, set config.enabled=false.

  config.access_token = ENV['ROLLBAR']

  # Enable asynchronous reporting (using sucker_punch)
  #config.use_sucker_punch

  # Enable delayed reporting (using Sidekiq)
  config.use_sidekiq

  # You can supply custom Sidekiq options:
  # config.use_sidekiq 'queue' => 'default'

  config.environment = Rails.env
end if Rails.env.production?
