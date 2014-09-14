class CampsController < ApplicationController
  before_action :set_camp, only: [:show, :edit, :update, :destroy]
  authorize_resource

  #Depending on the user who is accessing the index page we want to show him different things
  #other controllers are standard restful actions
  def index
    if current_user.nil?
      @upcoming_camps = Camp.upcoming.active.chronological.paginate(:page => params[:page]).per_page(10)
      @past_camps = Camp.past.chronological.paginate(:page => params[:page]).per_page(10)
      @inactive_camps = Camp.inactive.alphabetical.to_a
    elsif(current_user.role=="admin")
      @upcoming_camps = Camp.upcoming.active.chronological.paginate(:page => params[:page]).per_page(10)
      @past_camps = Camp.past.chronological.paginate(:page => params[:page]).per_page(10)
      @inactive_camps = Camp.inactive.alphabetical.to_a
    else(current_user.role=="instructor")
      @upcoming_camps = current_user.instructor.camps.active.chronological.paginate(:page => params[:page]).per_page(10)
      @past_camps = Camp.past.chronological.paginate(:page => params[:page]).per_page(10)
      @inactive_camps = Camp.inactive.alphabetical.to_a

    end
  end

  # show instructors as well as the registrations associated with the camp
  def show
    @instructors = @camp.instructors.alphabetical.to_a
    @camp_registrations=@camp.registrations
  end

  def new
    @camp = Camp.new
  end

  def edit
  end

  def create
    @camp = Camp.new(camp_params)
    if @camp.save
      redirect_to @camp, notice: "The camp #{@camp.name} (on #{@camp.start_date.strftime('%m/%d/%y')}) was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @camp.update(camp_params)
      redirect_to @camp, notice: "The camp #{@camp.name} (on #{@camp.start_date.strftime('%m/%d/%y')}) was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @camp.destroy
    redirect_to camps_url, notice: "#{@camp.name} camp on #{@camp.start_date.strftime('%m/%d/%y')} was removed from the system."
  end

  private
  def set_camp
    @camp = Camp.find(params[:id])
  end

  def camp_params
    params.require(:camp).permit(:curriculum_id, :location_id, :cost, :start_date, :end_date, :time_slot, :max_students, :active, :instructor_ids => [])
  end
end
