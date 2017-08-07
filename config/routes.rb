Rails.application.routes.draw do
  get 'game', to: 'matches#new'

  get 'score', to: 'matches#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
