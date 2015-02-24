class SetupController < ApplicationController

  def index
    @setup = Setup.new
    @setup.url = GitHub[:url]
    @setup.client_id = GitHub[:client_id]
    @setup.client_secret = GitHub[:client_secret]

  end

  def save
    @setup = params[:setup]
    GitHub['server']['url'] = @setup[:url]
    GitHub['server']['client_id'] = @setup[:client_id]
    GitHub['server']['client_secret'] = @setup[:client_secret]
    File.open("#{Rails.root.to_s}/config/github.yml",'w') {|f| f.write GitHub.to_yaml}
  end

end
