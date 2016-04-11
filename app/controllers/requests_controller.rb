class RequestsController < ApplicationController
  before_action :authenticate_user!
  layout 'subpage'
  
  def index
    @requests = Request.all
  end

  def new
    @request = Request.new
  end

  def create
    Request.insert(create_params)
    redirect_to root_path
  end

  def update
    Request.approve(approve_params)
  end

  private

  def approve_params
    permit = [:requester, :request_datetime, :topup_amount]
    params.permit(permit)
  end

  def create_params
    permit = [:requester, :topup_amount, :request_datetime]
    params.require(:request).permit(permit)
  end
end
