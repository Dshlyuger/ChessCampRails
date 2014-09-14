class LocationsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # want to separate locations into those that are active and those that are inactive
  # other actions are all standard templated restful actions
  def index
    @active_locations = Location.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_locations = Location.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
  end

  def new
    @location = Location.new
  end

  def edit
    # reformating the phone so it has dashes when displayed for editing (personal taste)
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to @location, notice: "#{@location.name} location was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @location.update(location_params)
      redirect_to @location, notice: "#{@location.name} location was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @location.destroy
    redirect_to locations_url, notice: "#{@location.name} was removed from the system."
  end

  private
  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name, :id, :street_1, :street_2, :city, :state, :zip, :max_capacity, :active, :latitude,:longitude)
  end
end
