class Admin::UsersController < ApplicationController
  def index
    @users = User.all.order(credit: :desc)
  end
end
