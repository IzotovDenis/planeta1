class ImportsController < ApplicationController
 include ActionController::Cookies
  def index
    if %w(checkauth init).include? params[:mode]
      puts '1'
      send(params[:mode])
    elsif (%w(file import).include? params[:mode]) && (@imp_session = Importsession.find_by(:cookie=>cookies[:import_cookie]))
      puts '2'
      send(params[:mode], @imp_session)
    else
      render :plain => "wrong response\n"
    end
  end

  private 

	def set_cookie
		Digest::SHA512.hexdigest(Time.now.to_s)
	end

  def checkauth
  	cookie = Importsession.create!(:cookie=>set_cookie,:exchange_type=>params[:exchange_type])
    puts "success\nimport_cookie\n#{cookie.cookie}\n"
  	render :plain => "success\nimport_cookie\n#{cookie.cookie}\n"
  end
  
  def init
    render :plain => "zip=yes\nfile_limit=20857600"
  end 

  def file(imp_session)
		tempfile = Tempfile.new("importupload")
		tempfile.binmode
		tempfile << request.body.read
		tempfile.rewind
		import_params = params.slice(:filename, :type, :head).merge(:tempfile => tempfile)
		importf = ActionDispatch::Http::UploadedFile.new(import_params)
		@import = Import.new
		@import.filename = importf
		@import.importsession = imp_session
		@import.save
  	render :plain => "success\n"
  end

  def import(imp_session)
    @importsession = imp_session
    unless @importsession.status == 'progress' || @importsession.status == 'success'
      @importsession.status = 'progress'
      @importsession.save
      ImportWorker.perform_async(@importsession.id)
    end
    sleep 10 if @importsession.status == "progress"
    render :plain => "#{@importsession.status}\n"
  end
end
