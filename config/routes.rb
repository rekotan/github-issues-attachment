GithubIssuesAttachment::Application.routes.draw do
  root :to => 'users#index'
  get 'users/index', :as => 'users'
  get 'users/logout', :as => 'users_logout'
  get 'auth/failure' => 'users#failure'
  get 'auth/github/callback' => 'users#callback'
  resources :attachments
  resources :github_issues
end
