Rails.application.routes.draw do
  root to: 'podcast_searches#index'
  resources :podcast_searches
end
