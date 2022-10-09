class WebsitesController < ApplicationController

  def index
    @websites = Website.all
  end

  def new
    @website = Website.new
  end

  def create
    @website = Website.new(website_params)
    if @website.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def website_params
    params.require(:website).permit(:name, :url)
  end
end
