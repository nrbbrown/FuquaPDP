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

    @AllGoals = Goal.where("user_id = ?  ", current_user.id)
	@overallScore = 0
	@domainScore = Hash["academic",0,"career",0,"social",0,"personal",0,"physical",0]
	@goalScore = Hash.new
	@domainActiveGoals = Hash["academic",0,"career",0,"social",0,"personal",0,"physical",0]
	@domainProgressedGoals = Hash["academic",0,"career",0,"social",0,"personal",0,"physical",0]
	@tasksEffortScore = Hash.new
    @privateGoals = Array.new
	@AllGoals.each do |onegoal|
		@goalScore[onegoal.id] = 0
		@activetasks = 0
		@tasksProgressed = 0
		onegoal.tasks.each do |onetask|
			@taskstart = Date.parse(onetask.startdue.strftime("%d %b %Y"))
			@taskend = Date.parse(onetask.due.strftime("%d %b %Y"))
			@tasksEffortScore[onetask.id] = 'N/A'
			if onegoal.is_private == 0 and ((@dateOfEntry.cweek >= @taskstart.cweek and @dateOfEntry.cweek <= @taskend.cweek) or  (@dateOfEntry.cwyear < @taskend.cwyear and @dateOfEntry > @taskstart))
				@activetasks = @activetasks + 1
				@tasksEffortScore[onetask.id] = '0%'
				onetask.tasksprogresses.each do |onevote|
					@taskVotedate = Date.parse(onevote.date.strftime("%d %b %Y"))
					if @taskVotedate.cweek == @dateOfEntry.cweek
						@tasksProgressed = @tasksProgressed + 1
						@tasksEffortScore[onetask.id] = '100%'
					end
				end
      elsif onegoal.is_private == 1 and ((@dateOfEntry.cweek >= @taskstart.cweek and @dateOfEntry.cweek <= @taskend.cweek) or  (@dateOfEntry.cwyear < @taskend.cwyear and @dateOfEntry > @taskstart))
        @privateGoals.push(onegoal.id)
        @activetasks = @activetasks + 1
        @tasksEffortScore[onetask.id] = '0%'
        onetask.tasksprogresses.each do |onevote|
          @taskVotedate = Date.parse(onevote.date.strftime("%d %b %Y"))
          if @taskVotedate.cweek == @dateOfEntry.cweek
            @tasksProgressed = @tasksProgressed + 1
            @tasksEffortScore[onetask.id] = '100%'
          end
        end
        @goalScore[onegoal.id] = "#{@tasksProgressed*100/@activetasks}%"
      end
		end
		if @activetasks == 0
			@goalScore[onegoal.id] = 'N/A'
    else
      @goalScore[onegoal.id] = "#{(@tasksProgressed*100.00/@activetasks).round(2)}%"
      if onegoal.is_private == 0
        @domainActiveGoals[onegoal.category] = @domainActiveGoals[onegoal.category].to_i + 1
        @domainProgressedGoals[onegoal.category] = @domainProgressedGoals[onegoal.category] + (@tasksProgressed*100.00/@activetasks)
      end
    end
	end
	@domainScore["academic"] = (@domainActiveGoals["academic"] == 0) ? 'N/A' : "#{(@domainProgressedGoals["academic"]/@domainActiveGoals["academic"]).round(2)}%"
	@domainScore["career"] = (@domainActiveGoals["career"] == 0) ? 'N/A' : "#{(@domainProgressedGoals["career"]/@domainActiveGoals["career"]).round(2)}%"
	@domainScore["social"] = (@domainActiveGoals["social"] == 0) ? 'N/A' : "#{(@domainProgressedGoals["social"]/@domainActiveGoals["social"]).round(2)}%"
	@domainScore["personal"] = (@domainActiveGoals["personal"] == 0) ? 'N/A' : "#{(@domainProgressedGoals["personal"]/@domainActiveGoals["personal"]).round(2)}%"
	@domainScore["physical"] = (@domainActiveGoals["physical"] == 0) ? 'N/A' : "#{(@domainProgressedGoals["physical"]/@domainActiveGoals["physical"]).round(2)}%"
    @overallActiveDomains = 0
    @overallScoreDomain = 0
    if @domainActiveGoals["academic"] != 0
      @overallActiveDomains = @overallActiveDomains + 1
      @overallScoreDomain = @overallScoreDomain + (@domainProgressedGoals["academic"]/@domainActiveGoals["academic"]).round(2)
    end
    if @domainActiveGoals["career"] != 0
      @overallActiveDomains = @overallActiveDomains + 1
      @overallScoreDomain = @overallScoreDomain + (@domainProgressedGoals["career"]/@domainActiveGoals["career"]).round(2)
    end
    if @domainActiveGoals["social"] != 0
      @overallActiveDomains = @overallActiveDomains + 1
      @overallScoreDomain = @overallScoreDomain + (@domainProgressedGoals["social"]/@domainActiveGoals["social"]).round(2)
    end
    if @domainActiveGoals["personal"] != 0
      @overallActiveDomains = @overallActiveDomains + 1
      @overallScoreDomain = @overallScoreDomain + (@domainProgressedGoals["personal"]/@domainActiveGoals["personal"]).round(2)
    end
    if @domainActiveGoals["physical"] != 0
      @overallActiveDomains = @overallActiveDomains + 1
      @overallScoreDomain = @overallScoreDomain + (@domainProgressedGoals["physical"]/@domainActiveGoals["physical"]).round(2)
    end
    @overallScore = (@overallActiveDomains == 0) ? 'N/A' : (@overallScoreDomain*1.00/@overallActiveDomains).round(2)
	
	@academicGoals = Goal.where("user_id = ? and category = ? and is_private = 0 ", current_user.id, :academic)
	@careerGoals = Goal.where("user_id = ? and category = ?  and is_private = 0 ", current_user.id, :career)
	@personalGoals = Goal.where("user_id = ? and category = ?  and is_private = 0 ", current_user.id, :personal)
	@physicalGoals = Goal.where("user_id = ? and category = ? and is_private = 0 ", current_user.id, :physical)
	@socialGoals = Goal.where("user_id = ? and category = ? and is_private = 0 ", current_user.id, :social)


    @academicPrivateGoals = Goal.where("user_id = ? and category = ? and is_private = 1 ", current_user.id, :academic)
    @careerPrivateGoals = Goal.where("user_id = ? and category = ?  and is_private = 1 ", current_user.id, :career)
    @personalPrivateGoals = Goal.where("user_id = ? and category = ?  and is_private = 1 ", current_user.id, :personal)
    @physicalPrivateGoals = Goal.where("user_id = ? and category = ? and is_private = 1 ", current_user.id, :physical)
    @socialPrivateGoals = Goal.where("user_id = ? and category = ? and is_private = 1 ", current_user.id, :social)

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
