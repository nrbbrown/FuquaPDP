class ScorecardController < ApplicationController
  def index
    @uid = (params[:u] != nil) ? params[:u] : current_user.id
	@thisWeek = (params[:week] != nil) ? params[:week] : Date.today.cweek
	@isCurrentWeek = (@thisWeek.to_i == Date.today.cweek.to_i) ? true :	false
	@dateOfEntry = Date.commercial(Date.today.year.to_i, @thisWeek.to_i, 1)
	@endDateEntry = @dateOfEntry + 6
	@minDate =  Date.parse(Task.minimum('startdue').strftime("%d %b %Y"))
	@maxDate =  Date.parse(Task.maximum('due').strftime("%d %b %Y"))
	@AllGoals = Goal.where("user_id = ? ", current_user.id)
	@overallScore = 0
	@overallActiveTasks = 0
	@overallProgressedTasks = 0
	@domainScore = Hash["academic",0,"career",0,"social",0,"personal",0,"physical",0]
	@goalScore = Hash.new
	@domainActiveTasks = Hash["academic",0,"career",0,"social",0,"personal",0,"physical",0]
	@domainProgressedTasks = Hash["academic",0,"career",0,"social",0,"personal",0,"physical",0]
	@tasksEffortScore = Hash.new
	@AllGoals.each do |onegoal|
		@goalScore[onegoal.id] = 0
		@activetasks = 0
		@tasksProgressed = 0
		onegoal.tasks.each do |onetask|
			@taskstart = Date.parse(onetask.startdue.strftime("%d %b %Y"))
			@taskend = Date.parse(onetask.due.strftime("%d %b %Y"))
			@tasksEffortScore[onetask.id] = 'N/A'
			if (@dateOfEntry.cweek >= @taskstart.cweek and @dateOfEntry >= @taskstart and @dateOfEntry.cweek <= @taskend.cweek) 
				@activetasks = @activetasks + 1
				@tasksEffortScore[onetask.id] = '0%'
				@overallActiveTasks = @overallActiveTasks + 1
				@domainActiveTasks[onegoal.category] = @domainActiveTasks[onegoal.category].to_i + 1
				onetask.tasksprogresses.each do |onevote|
					@taskVotedate = Date.parse(onevote.date.strftime("%d %b %Y"))
					if @taskVotedate.cweek == @dateOfEntry.cweek
						@tasksProgressed = @tasksProgressed + 1
						@tasksEffortScore[onetask.id] = '100%'
						@overallProgressedTasks = @overallProgressedTasks + 1
						@domainProgressedTasks[onegoal.category] = @domainProgressedTasks[onegoal.category].to_i + 1
					end
				end
				@goalScore[onegoal.id] = "#{@tasksProgressed*100/@activetasks}%"
			end
		end
		if @activetasks == 0
			@goalScore[onegoal.id] = 'N/A'
		end
	end
	@domainScore["academic"] = (@domainActiveTasks["academic"] == 0) ? 'N/A' : "#{@domainProgressedTasks["academic"]*100/@domainActiveTasks["academic"]}%"
	@domainScore["career"] = (@domainActiveTasks["career"] == 0) ? 'N/A' : "#{@domainProgressedTasks["career"]*100/@domainActiveTasks["career"]}%"
	@domainScore["social"] = (@domainActiveTasks["social"] == 0) ? 'N/A' : "#{@domainProgressedTasks["social"]*100/@domainActiveTasks["social"]}%"
	@domainScore["personal"] = (@domainActiveTasks["personal"] == 0) ? 'N/A' : "#{@domainProgressedTasks["personal"]*100/@domainActiveTasks["personal"]}%"
	@domainScore["physical"] = (@domainActiveTasks["physical"] == 0) ? 'N/A' : "#{@domainProgressedTasks["physical"]*100/@domainActiveTasks["physical"]}%"
	@overallScore = (@overallActiveTasks == 0) ? 'N/A' : (@overallProgressedTasks*100/@overallActiveTasks)
	
	@academicGoals = Goal.where("user_id = ? and category = ?", current_user.id, :academic)
	@careerGoals = Goal.where("user_id = ? and category = ?", current_user.id, :career)
	@personalGoals = Goal.where("user_id = ? and category = ?", current_user.id, :personal)
	@physicalGoals = Goal.where("user_id = ? and category = ?", current_user.id, :physical)
	@socialGoals = Goal.where("user_id = ? and category = ?", current_user.id, :social)
	
	@overallCompleteTasks = 0
	@overallTasks = 0
	@domainTasks = Hash["academic",0,"career",0,"social",0,"personal",0,"physical",0]
	@domainCompleteTasks = Hash["academic",0,"career",0,"social",0,"personal",0,"physical",0]
	@goalCompleteScore = Hash.new
	@domainCompleteScore = Hash.new
	@AllGoals.each do |onegoal|
		@goalCompleteScore[onegoal.id] = 0
		onegoal.tasks.each do |onetask|
			@domainTasks[onegoal.category] = @domainTasks[onegoal.category] + 1
			@overallTasks = @overallTasks + 1
			if onetask.is_complete? == true and onetask.completed_at != nil
				@taskCompletedAt = Date.parse(onetask.completed_at.strftime("%d %b %Y"))
				if @taskCompletedAt.cweek <= @dateOfEntry.cweek
					@overallCompleteTasks = @overallCompleteTasks + 1
					@domainCompleteTasks[onegoal.category] = @domainCompleteTasks[onegoal.category] + 1
					@goalCompleteScore[onegoal.id] = @goalCompleteScore[onegoal.id] + 1 
				end
			end
		end
	end
	
	@domainCompleteScore["academic"] = (@domainTasks["academic"] == 0) ? 'N/A' : "#{@domainCompleteTasks["academic"]*100/@domainTasks["academic"]}%"
	@domainCompleteScore["career"] = (@domainTasks["career"] == 0) ? 'N/A' : "#{@domainCompleteTasks["career"]*100/@domainTasks["career"]}%"
	@domainCompleteScore["social"] = (@domainTasks["social"] == 0) ? 'N/A' : "#{@domainCompleteTasks["social"]*100/@domainTasks["social"]}%"
	@domainCompleteScore["personal"] = (@domainTasks["personal"] == 0) ? 'N/A' : "#{@domainCompleteTasks["personal"]*100/@domainTasks["personal"]}%"
	@domainCompleteScore["physical"] = (@domainTasks["physical"] == 0) ? 'N/A' : "#{@domainCompleteTasks["physical"]*100/@domainTasks["physical"]}%"
	@overallCompleteScore = (@overallTasks == 0) ? 'N/A' : (@overallCompleteTasks*100/@overallTasks)
	
  end
end
