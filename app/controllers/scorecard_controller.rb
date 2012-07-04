class ScorecardController < ApplicationController

  before_filter :authenticate_user!

  def index
    @activeTab = 1
    @users = User.find(:all,:order=>"name")
  @uid = (params[:u] != nil) ? params[:u] : current_user.id
	@thisWeek = (params[:week] != nil) ? params[:week] : Time.zone.today.cweek
	@isCurrentWeek = (@thisWeek.to_i == Time.zone.today.cweek.to_i) ? true :	false
	@dateOfEntry = Date.commercial(Time.zone.today.year.to_i, @thisWeek.to_i, 1)
	@endDateEntry = @dateOfEntry + 6
    @minDate = Time.zone.today
    @maxDate = Time.zone.today
    @taskStartMin = Task.minimum('startdue')
    if @taskStartMin != nil
      @minDate =  Date.parse(@taskStartMin.strftime("%d %b %Y"))
    end
    @taskDueMin = Task.maximum('due')

    @AllGoals = Goal.where("user_id = ? and is_private = 0 ", current_user.id)
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
			if (@dateOfEntry.cweek >= @taskstart.cweek and @dateOfEntry.cweek <= @taskend.cweek) or  (@dateOfEntry.cwyear < @taskend.cwyear and @dateOfEntry > @taskstart)
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
	
	@academicGoals = Goal.where("user_id = ? and category = ? and is_private = 0 ", current_user.id, :academic)
	@careerGoals = Goal.where("user_id = ? and category = ?  and is_private = 0 ", current_user.id, :career)
	@personalGoals = Goal.where("user_id = ? and category = ?  and is_private = 0 ", current_user.id, :personal)
	@physicalGoals = Goal.where("user_id = ? and category = ? and is_private = 0 ", current_user.id, :physical)
	@socialGoals = Goal.where("user_id = ? and category = ? and is_private = 0 ", current_user.id, :social)
	

  end

  def ileteams
    @activeTab = 2
    @uid = (params[:u] != nil) ? params[:u] : current_user.id
    @thisWeek = (params[:week] != nil) ? params[:week] : Time.zone.today.cweek
    @dateOfEntry = Date.commercial(Time.zone.today.year.to_i, @thisWeek.to_i, 1)
    @endDateEntry = @dateOfEntry + 6
    @minDate = Time.zone.today
    @maxDate = Time.zone.today
    @taskStartMin = Task.minimum('startdue')
    if @taskStartMin != nil
      @minDate =  Date.parse(@taskStartMin.strftime("%d %b %Y"))
    end
    @taskDueMin = Task.maximum('due')

    @activeTasks = Task.find_by_sql [" select count(distinct t.id) as active, u.ileteam  as ileteam
                                        from tasks t
                                        join goals g
                                        on t.goal_id = g.id
                                        join users u
                                        on u.id = t.user_id
                                        where g.is_private = 0
                                        and t.startdue <= now()
                                        and date_part('week',t.due) >= ?
                                        group by u.ileteam
                                        order by u.ileteam asc ",@thisWeek]
    @teamActiveTasks = Hash.new
    @activeTasks.each do |oneteam|
        @teamActiveTasks[oneteam.ileteam] = oneteam.active
    end

    @doneTasks = Task.find_by_sql [" select count(distinct t.id) as done, u.ileteam  as ileteam
                                        from tasks t
                                        join goals g
                                        on t.goal_id = g.id
                                        join users u
                                        on u.id = t.user_id
                                        join tasksprogresses tp
                                        on tp.task_id = t.id
                                        where g.is_private = 0
                                        and t.startdue <= now()
                                        and date_part('week',t.due) >= ?
                                        and date_part('week',tp.date) = ?
                                        group by u.ileteam
                                        order by u.ileteam asc  ",@thisWeek,@thisWeek]
    @teamDoneTasks = Hash.new
    @doneTasks.each do |onedteam|
      @teamDoneTasks[onedteam.ileteam] = onedteam.done
    end

  end
end
