class ScoreentryController < ApplicationController
	
	before_filter :authenticate_user!
	
  def index
	@academicGoals = Goal.where("user_id = ? and category = ?", current_user.id, :academic)
	@careerGoals = Goal.where("user_id = ? and category = ?", current_user.id, :career)
	@personalGoals = Goal.where("user_id = ? and category = ?", current_user.id, :personal)
	@physicalGoals = Goal.where("user_id = ? and category = ?", current_user.id, :physical)
	@socialGoals = Goal.where("user_id = ? and category = ?", current_user.id, :social)
	@dateOfEntry = Date.today
  end
  
  # Get /scoreentry/1
  # get /scoreentry/1.json
  def edit
	is_complete = params[:is_complete]
    @task = Task.find(params[:taskid])
	@goal = Goal.find(@task.goal_id)
	respond_to do |format|
		@task.update_attribute("is_complete",is_complete)
		@goalComplete = 1
		@goal.tasks.each do |onetask|
			if onetask.is_complete? == false
				@goalComplete = 0
			end
		end
		@goal.update_attribute("is_complete",@goalComplete)
		format.html { render :nothing => true }
		format.js { render :json => 1}
	end
  end
end
