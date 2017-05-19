class SetGroupAndSortItemsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(importsession_id)
	ImportCommands.set_group(importsession_id)
	ImportCommands.sort_items
	GroupsCommands.set_new_item_time
  end

end