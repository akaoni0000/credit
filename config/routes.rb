Rails.application.routes.draw do
  devise_for :users
  root "home#top"
  resources :card, only: [:new, :show] do
    collection do
      post 'show', to: 'card#show'
      post 'pay', to: 'card#pay'
      post 'delete', to: 'card#delete'
    end
  end
  post "card/purchase" => "card#purchase",  as: "purchase"
  post "card/purchase2" => "card#purchase2"
end
