class ApplicationController < ActionController::Base
  before_action :repository_info, only: [:index, :show, :edit, :new]

  def repository_info
    @repo = RepositoryFacade.repo_or_error_message
  end
end
