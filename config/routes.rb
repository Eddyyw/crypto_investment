# frozen_string_literal: true

Rails.application.routes.draw do
  root 'calculate_investment#index'

  post '/calculate', to: 'calculate_investment#calculate_projection'
  post '/print_projection', to: 'calculate_investment#print_projection', defaults: { format: 'csv' }

  get '/projection', to: 'calculate_investment#calculate_projection'
end
