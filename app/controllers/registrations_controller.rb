class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @registrations = Registration.all
  end


  def show
  end

 # Registrations are created through from the camp show page
 # So when creating a registration we get the approrpriate camp and also associate
 # it's camp_id with the input camp_id from the camp page that creates the registration.
 # We also filter out the students that are not eligible for that camp using
 # the camps curriculum ratings
  def new
    @registration = Registration.new
    unless params[:camp_id].nil?
      @registration.camp_id = params[:camp_id]
    end
    @camp=Camp.find(params[:camp_id])
    min_rating=@camp.curriculum.min_rating
    max_rating=@camp.curriculum.max_rating

    @valid_students=Student.active.at_or_above_rating(min_rating).below_rating(max_rating)

  end

  # GET /registrations/1/edit
  def edit
  end

  # POST /registrations
  # POST /registrations.json
  def create
    @registration = Registration.new(registration_params)
    @registration.save!
    if @registration.save
      redirect_to camp_path(@registration.camp)

    else
      render action: 'new'
    end
  end

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    respond_to do |format|
      if @registration.update(registration_params)

        format.html { redirect_to @registration, notice: 'Registration was successfully updated.' }
        format.json { head :no_content }

      else
        format.html { render action: 'edit' }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    oldcamp=@registration.camp
    @registration.destroy
    redirect_to camp_path(oldcamp)

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_registration
    @registration = Registration.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def registration_params
    params.require(:registration).permit(:id, :camp_id, :payment_status, :points_earned,:student_id)
  end
end
