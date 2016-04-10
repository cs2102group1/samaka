class Admin::UsersController < ApplicationController
  layout 'subpage'
  def index
    @users = []
    if params[:q]
      case params[:q]
      when 'top_spenders'
        @title = 'Maximum spent on a ride'
        @users = User.top_spenders
      when 'frequent_riders'
        @title = 'Number of rides taken'
        @users = User.frequent_riders
      when 'super_drivers'
        @title = 'Number of rides offered'
        @users = User.super_drivers
      end
    end
  end
end
