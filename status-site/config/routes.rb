StatusGitoriousOrg::Application.routes.draw do
  resources :statuses, :except => :destroy

  resources :sessions

  root :to => "statuses#current"
end
