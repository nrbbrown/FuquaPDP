class ScoreentryController < ApplicationController
	
	before_filter :authenticate_user!
	
  def index
    @uid = (params[:u] != nil) ? params[:u] : current_user.id
	@academicGoals = Goal.where("user_id = ? and category = ?", current_user.id, :academic)
	@careerGoals = Goal.where("user_id = ? and category = ?", current_user.id, :career)
	@personalGoals = Goal.where("user_id = ? and category = ?", current_user.id, :personal)
	@physicalGoals = Goal.where("user_id = ? and category = ?", current_user.id, :physical)
	@socialGoals = Goal.where("user_id = ? and category = ?", current_user.id, :socialGoals)
	@thisWeek = (params[:week] != nil) ? params[:week] : Date.today.cweek
	@isCurrentWeek = (@thisWeek.to_i == Date.today.cweek.to_i) ? true :	false
	@dateOfEntry = Date.commercial(Date.today.year.to_i, @thisWeek.to_i, 1)
	@minDate =  Date.parse(Task.minimum('startdue').strftime("%d %b %Y"))
	@maxDate =  Date.parse(Task.maximum('due').strftime("%d %b %Y"))
  end
  
  # Get /scoreentry/1
  # get /scoreentry/1.json
  def edit
	@is_complete = params[:is_complete].to_i
    @task = Task.find(params[:taskid])
	@goal = Goal.find(@task.goal_id)
	@dateup = Date.commercial(Date.today.year.to_i, Date.today.cweek.to_i, 1)
	respond_to do |format|
		if @is_complete == 1
			@taskProgress = Tasksprogress.new(:task_id =>params[:taskid],:date =>@dateup, :created_at =>DateTime.now, :updated_at =>DateTime.now)
			@taskProgress.save
		end
		@task.update_attributes(:is_complete => @is_complete,:completed_at => Date.today)
		@goalComplete = 1
		@goal.tasks.each do |onetask|
			if onetask.is_complete? == false
				@goalComplete = 0
			end
		end
		@goal.update_attributes(:is_complete => @goalComplete,:completed_at => Date.today)
		format.html { render :nothing => true }
		format.js { render :json => 1}
	end
  end
end
