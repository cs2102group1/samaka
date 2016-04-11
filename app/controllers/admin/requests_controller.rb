class Admin::RequestsController < ApplicationController
  before_action :authorized?
  layout 'contentpage'
  
  def index
    @requests = Request.all
  end

  def create
    Request.insert(create_params)
    redirect_to admin_requests_path
  end

  def update
    Request.approve(approve_params)
    redirect_to admin_requests_path
  end

  def show
    @requests = Request.find(find_params)
    redirect_to admin_requests_path
  end

  def destroy
    Request.delete(delete_params)
    redirect_to admin_requests_path
  end

  private

  def authorized?
    current_user.is_admin?
  end

  def find_params
    permit = [:requester, :request_datetime]
    params.permit(permit)
  end

  def approve_params
    permit = [:requester, :request_datetime, :topup_amount]
    params.permit(permit)
  end

  def delete_params
    permit = [:requester, :request_datetime, :topup_amount]
    params.permit(permit)
  end

  def create_params
    permit = [:requester, :topup_amount, :request_datetime]
    params.require(:request).permit(permit)
  end
end
