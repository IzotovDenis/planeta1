class ActivityWorker
	include Sidekiq::Worker

	def perform(hash)
		Activity.router(hash)
	end

end