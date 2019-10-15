Rails.application.routes.draw do
  root 'users#index'

  namespace :user do
    granite 'ba/user/create#page'
  end

end
