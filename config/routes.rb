Rottenpotatoes::Application.routes.draw do
 
  match 'movies?(item=:item&)ratings[i]=i'=>'movies#index'
  match 'movies?ratings[i]=i'=>'movies#index'

  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  post '/movies/search_tmdb'
end
