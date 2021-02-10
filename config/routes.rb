# frozen_string_literal: true

Rails.application.routes.draw do
  resource :ping_statistics, only: :show
  resources :host_monitorings, only: :create do
    collection do
      resource :stop, only: :create, module: :host_monitorings
    end
  end
end
