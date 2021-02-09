# frozen_string_literal: true

Rails.application.routes.draw do
  resource :ping_statistics, only: :show
end
