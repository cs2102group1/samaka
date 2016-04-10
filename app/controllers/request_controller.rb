class RequestController < ApplicationController
  def index
    @requests = Request.all
  end

  def new
    @request = Request.new
  end

  def create
    Request.insert(create_params)
  end

  def approve
    Request.approve(approve_params) 
  end

  private

  def approve_params
    permit = [:requester, :request_datetime, :topup_amount]
    params.permit(permit)
  end

  def create_params
    permit = [:requester, :status, :topup_amount, :request_datetime]
    params.permit(permit)
  end
end
