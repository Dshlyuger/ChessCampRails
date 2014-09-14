class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.role? :admin
      can :manage, :all
    elsif user.role? :instructor

      can :update, Instructor do |instructor|
        instructor.id==user.instructor_id
      end

      can :read, Instructor do |instructor|
        instructor.id==user.instructor_id
      end


      can :read, Camp do |camp|
      
      instructor_ids=camp.instructors.map{|elem| elem.id }
      instructor_ids.include?(user.instructor_id)
      end

      can :read, Student do |student|  

        instructor=user.instructor
        camps=instructor.camps
        
        all_students_array=camps.map{|elem| elem.students}
        all_students=all_students_array.flatten
        all_students_ids=all_students.map{|elem| elem.id}

        all_students_ids.include?(student.id)
        
        end

    else
      can :read, Location
      can :read, Instructor

      can :read, Camp do |camp|
      
      upcoming_camp_ids=Camp.upcoming.map{|elem| elem.id }
      upcoming_camp_ids.include?(camp.id)
      end

       
    end
  end

end
