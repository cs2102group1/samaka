class PassengersController < ApplicationController
  def create
    Passenger.insert(create_params)
    redirect_to journeys_path
  end

  def offboard
    Passenger.update(edit_params, current_user.email)
    redirect_to journeys_path
  end

  private

  def create_params
    permit = [:email, :start_time, :car_plate, :onboard]

    params.permit(permit)
  end

  def edit_params
    permit = [:start_time, :car_plate, :onboard]

    params.permit(permit)
  end
end