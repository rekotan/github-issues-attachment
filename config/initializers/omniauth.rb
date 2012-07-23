Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_ID'], ENV['GITHUB_SECRET'],
    :scope => 'repo', :skip_info => lambda{|uid| true}
end
