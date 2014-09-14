class HomeController < ApplicationController
  # Each different role gets a seperate home page.
  def index
    if (current_user.nil?)
      @upcoming_camps = Camp.upcoming.active.chronological.paginate(:page => params[:page]).per_page(7)
    elsif(!current_user.nil? && current_user.role=="instructor")
      @upcoming_camps = current_user.instructor.camps.active.chronological.paginate(:page => params[:page]).per_page(7)
      @instructor=current_user.instructor
    else
      @upcoming_camps = current_user.instructor.camps.active.chronological.paginate(:page => params[:page]).per_page(6)
      @deposit_only = Registration.deposit_only.paginate(:page => params[:page]).per_page(6)
      @total=Registration.all.paid.to_a.size
      @deposit_only_total=Registration.all.deposit_only.to_a.size
      @paid = Registration.paid.by_student.paginate(:page => params[:page]).per_page(6)
      @instructor_assignments=CampInstructor.all.paginate(:page => params[:page]).per_page(6)
    end

  end

  def about
  end

  def contact
  end

  def privacy
  end

end
