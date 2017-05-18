class GroupSetStructureWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(importsession_id)
	ImportCommands.set_parent_group
	ImportCommands.set_disabled_group
	Group.where.not(:importsession_id=>importsession_id).each do |group|
		group.set_disabled
	end
  end

end