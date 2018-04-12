Rails.application.configure do
	 # using sidekiq for asynch mail sending
	 config.active_job.queue_adapter = :sidekiq

end