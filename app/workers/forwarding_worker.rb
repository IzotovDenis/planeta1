class ForwardingWorker
  include Sidekiq::Worker

  def perform(order_id)
  	  	OrderMailer.order_from(order_id).deliver
  end
end