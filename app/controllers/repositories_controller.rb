class RepositoriesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_repository, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    client = Octokit::Client.new(:access_token => current_user.token, :api_endpoint => "#{GitHub['server']['url']}/api/v3")
    name = params[:name]
    if name.nil? || current_user['name'].eql?(name)
      @repositories = client.repositories
    else
      @repositories = client.organization_repositories(name)
    end
    @orgs = client.organization_memberships
    puts @orgs.inspect
    respond_with(@repositories, @orgs)
  end

  def show
    respond_with(@repository)
  end

  def new
    @repository = Repository.new
    respond_with(@repository)
  end

  def edit
  end

  def create
    @repository = Repository.new(repository_params)
    @repository.save
    respond_with(@repository)
  end

  def update
    @repository.update(repository_params)
    respond_with(@repository)
  end

  def destroy
    @repository.destroy
    respond_with(@repository)
  end

  private
    def set_repository
      @repository = Repository.find(params[:id])
    end

    def repository_params
      params[:repository]
    end
end
