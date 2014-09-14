class InstructorsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]
  authorize_resource

  #splitting up instructors into active and inactive ones for the index page
  def index
    @active_instructors = Instructor.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_instructors = Instructor.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  # want to show the upcoming and past camps separtley
  # other actions are standard restful templated actions
  def show
    @upcoming_camps = @instructor.camps.upcoming.chronological
    @past_camps = @instructor.camps.past.chronological
  end

  def new
    @instructor = Instructor.new
    @instructor.build_user
  end

  def edit
    # reformating the phone so it has dashes when displayed for editing (personal taste)
    @instructor.phone = number_to_phone(@instructor.phone)
    if(@instructor.user.nil?)
      @instructor.build_user
    end
  end

  def create
    @instructor = Instructor.new(instructor_params)
    if @instructor.save
      redirect_to @instructor, notice: "#{@instructor.proper_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @instructor.update(instructor_params)
      redirect_to @instructor, notice: "#{@instructor.proper_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @instructor.destroy
    redirect_to instructors_url, notice: "#{@instructor.proper_name} was removed from the system."
  end

  private
  def set_instructor
    @instructor = Instructor.find(params[:id])
  end
  # create users in instructor form so we also cover user attributes
  def instructor_params
    params.require(:instructor).permit(:first_name, :id, :last_name, :bio, :email, :phone, :active, :picture, user_attributes: [:id,:username, :password, :password_confirmation,:role,:instructor_id,:active])
  end
end
