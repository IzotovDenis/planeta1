class ImportWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(importsession_id,change=true)
  	@importsession = Importsession.find_by_id(importsession_id) || Importsession.create(:status=>'progress',:cookie=>"Full")
  		if change
			system ("cat imports/#{@importsession.id.to_s}/imp.zip.* > imports/#{@importsession.id.to_s}/import.zip")
			system ("unzip imports/#{@importsession.id.to_s}/import.zip -d imports/#{@importsession.id.to_s}/")
			@path = "imports/#{@importsession.id.to_s}"
		else
			system ("mkdir -p imports/#{@importsession.id.to_s}/")
			system ("unzip basic/import.zip -d imports/#{@importsession.id.to_s}/")
			@path = "imports/#{@importsession.id.to_s}/"
			#@path = "/media/1C5E04585E042CD8/1cbitrix"
		end
		if ImportCommands.import1c(@importsession.id)
			@importsession.status = 'success'
			@importsession.save
		end
  end

end