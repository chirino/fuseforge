require 'net/http'
require 'uri'

class DownloadRequestsController < ApplicationController
  before_filter :get_project
  before_filter :set_return_to

  allow :user => :is_registered_user?, :redirect_to => '/'

  def create
#    begin
#      url = URI.parse(params[:url])
#      response = Net::HTTP.start(url.host, url.port) { |http| http.head(url.path) }
#      raise unless response.code == '200'
#    rescue 
#      render :action => :error
#      return      
#    end

    @download_request = DownloadRequest.new 
    @download_request.url = params[:url]
    @download_request.description = params[:desc]
    @download_request.project = @project
    @download_request.save

    redirect_to @download_request.url    
  end

  private
  
  def get_project
    @project = Project.find(params[:project_id])
  end
  
  def set_return_to
    get_project
    session[:return_to] = "#{FUSEFORGE_URL}/projects/#{@project.shortname}"
  end
end
