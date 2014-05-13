class SiteController < ApplicationController
  def index
  end

  def show
    render params[:id].gsub(/-/, "_")
  end
end
