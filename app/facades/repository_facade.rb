class RepositoryFacade

  # these methods are important to handle hitting rate limits
  def self.repo_or_error_message
    json = GithubService.get_repo_data
    json[:message].nil? ? create_repo : json  #if :message is not present, this will return an error message
  end

  def self.create_repo
    json = GithubService.get_repo_data
    Repository.new(json)
  end
end