class PagesController < ApplicationController

  def index
  end

  def registration_complete
    render layout: 'subpage'
  end
end
