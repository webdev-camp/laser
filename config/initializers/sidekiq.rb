Sidekiq.configure_server do |config|
# default config.redis = { url: 'redis://localhost:6379/0'  }
  schedule_file = "config/schedule.yml"
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

Sidekiq.configure_client do |config|
#default  config.redis = { url: 'redis://localhost:6379/0'  }
end
