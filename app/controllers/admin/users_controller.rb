class Admin::UsersController < ApplicationController
  layout 'subpage'
  def index
    @users = User.leaderboard
  end
end
