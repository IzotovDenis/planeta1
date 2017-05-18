class ApiController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    render :json=>{success: false, error: "not auth"}
  end
end
