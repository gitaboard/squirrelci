class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @repositories = Repository.all
    respond_with(@repositories)
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
