class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  layout 'contentpage'
  def index
    if authorized?
      @title = 'Credit'
      @users = User.all.order(credit: :desc) 
    else 
      @users = []
    end
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

  private
  def authorized?
    current_user.admin?
  end
end
