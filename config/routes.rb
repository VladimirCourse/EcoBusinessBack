Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'planner/flights', action: :flights, controller: 'planner'
  get 'planner/buses', action: :buses, controller: 'planner'
  get 'planner/trains', action: :trains, controller: 'planner'
  get 'planner/hotels', action: :hotels, controller: 'planner'
  get 'planner/transfer/cars', action: :car_transfer, controller: 'planner'

end
