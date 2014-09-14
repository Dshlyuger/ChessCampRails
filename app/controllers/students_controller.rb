class StudentsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  # We seperate students b those that are active and those that aren't
  # the rest of the actions are standard rails templated restful actions
  def index
    @active_students = Student.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_students = Student.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @student_camps=@student.camps.chronological
  end

  def new
    @student = Student.new
  end

  def edit
    # reformating the phone so it has dashes when displayed for editing (personal taste)
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      redirect_to @student, notice: "#{@student.first_name+ " " + @student.last_name}  was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @student.update(student_params)
      redirect_to @student, notice: "#{@student.first_name+ " " + @student.last_name}  was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @student.destroy
    redirect_to students_url, notice: "#{@student.first_name+ " " + @student.last_name} student was removed from the system."
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:id, :first_name, :last_name, :family_id, :date_of_birth, :rating, :active)
  end
end
