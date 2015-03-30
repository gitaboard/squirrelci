class RepositoriesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_repository, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    client = Octokit::Client.new(:access_token => current_user.token, :api_endpoint => "#{GitHub['server']['url']}/api/v3")
    name = params[:name]
    if name.nil? || current_user['name'].eql?(name)
      _repo = client.repositories
      @repositories = Array.new
      @repositories_enabled = Array.new
      _repo.each do |r|
        if Repository.where(repo_id: r.id).count == 0
          @repositories << r
        else
          @repositories_enabled << r
        end
      end
    else
      @repositories = Array.new
      @repositories_enabled = Array.new
      begin
        _repo = client.organization_repositories(name)
        _repo.each do |r|
          if Repository.where(repo_id: r.id).count == 0
            @repositories << r
          else
            @repositories_enabled << r
          end
        end
      rescue
        puts "no repos found"
      end
    end
    @orgs = client.organization_memberships
    respond_with(@repositories, @repositories_enabled, @orgs)
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

  def search
  end

  def create
    client = Octokit::Client.new(:access_token => current_user.token, :api_endpoint => "#{GitHub['server']['url']}/api/v3")
    repo = params[:repository]
    gh_repo = client.repository(repo['repository_id'].to_i)
    client.create_hook(gh_repo['id'], 'web', {:url => "http://#{request.remote_ip}:3000/builds", :content_type => 'json'}, {:events => ['push', 'pull_request'], :active => true})
    @repository = Repository.create(:repo_id => gh_repo['id'], :full_name => gh_repo['full_name'], :owner => gh_repo['owner']['login'])
    redirect_to repositories_url
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
