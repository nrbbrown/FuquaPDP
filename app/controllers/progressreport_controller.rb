class ProgressreportController < ApplicationController
  before_filter :authenticate_user!
    
  # GET /progressreport
  # GET /progressreport.json
  def index
    @isedit = false
    @allGoals = Goal.where("user_id = ?", current_user.id)
	@completeGoals = Hash.new
	@completeTasks = Hash.new
	@percentGoalCompleted = Hash.new
	@categoryComplete = Hash["academic",0,"career",0,"social",0,"personal",0,"physical",0]
	@totalCategoryGoals = Hash.new
	@allGoals.each do |onegoal|
		@totalCategoryGoals[onegoal.category] = @totalCategoryGoals[onegoal.category].to_i + 1
	end
	@allGoals.each do |onegoal|
		if (onegoal.is_complete?) 
			@completeGoals[onegoal.category] = @completeGoals[onegoal.category].to_i + 1
		end
		@completedTask = 0
		onegoal.tasks.each do |onetask|
			if(onetask.is_complete?)
				@completedTask+=1
			end
		end
		@completeTasks[onegoal.id] = @completedTask
		@percentGoalCompleted[onegoal.id] = (@completeTasks[onegoal.id]*100/onegoal.tasks.length)
		@categoryComplete[onegoal.category] = @categoryComplete[onegoal.category].to_i + @percentGoalCompleted[onegoal.id].to_i
	end
	@overallCompleted = 0
	@categoryComplete.each do |onecategory,c|
		if(@totalCategoryGoals[onecategory].to_i == 0)
			@categoryComplete[onecategory] = c.to_i
		else
			@categoryComplete[onecategory] = c.to_i/@totalCategoryGoals[onecategory].to_i
		end
		@overallCompleted = @overallCompleted.to_i + @categoryComplete[onecategory].to_i
	end
	@overallCompleted = @overallCompleted.to_i/@allGoals.length
	
	
  end

  before_filter :authenticate_user!
  
  # GET /progressreport/1/admin
  def admin
	@allUserGoals = Goal.find_by_sql("select g.user_id, u.name ,
										count(distinct g.id) as totalGoals,
										count(distinct t.id) as totalTasks,
										sum(g.is_complete) as completedGoals ,
										sum(t.is_complete) as completedTasks 
									from goals g
									join tasks t
									on g.id = t.goal_id
									join users u
									on u.id=g.user_id
									where 1=1
									group by g.user_id,u.name
									")
  end
end
