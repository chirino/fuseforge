require 'net/http'
require 'uri'

class DownloadRequestsController < ApplicationController
  allow :exec => :user => :is_registered_user?, :redirect_to => '/'

  def create
    begin
      url = URI.parse(params[:file])
      response = Net::HTTP.start(url.host, url.port) { |http| http.head(url.path) }
      raise unless response.code == '200'
    rescue 
      render :action => :error
      return      
    end

    @download_request = DownloadRequest.new 
    @download_request.url = params[:file]
    @download_request.description = params[:desc]
    @download_request.project = Project.find(params[:project_id])
    @download_request.save

    redirect_to @download_request.url    
  end
end
