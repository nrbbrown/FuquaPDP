class ScorecardController < ApplicationController

  before_filter :authenticate_user!

  def index
    @activeTab = 1
    @users = User.where("1=1",:order=>"name")
  @uid = (params[:u] != nil) ? params[:u] : current_user.id
    @thisUser = User.find_by_id(@uid)
    if @thisUser == nil
      @uid = current_user.id
      @thisUser = User.find_by_id(@uid)
    end
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

    @AllGoals = Goal.where("user_id = ?  ", @uid)
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
	
	@academicGoals = Goal.where("user_id = ? and category = ? and is_private = 0 ", @uid, :academic)
	@careerGoals = Goal.where("user_id = ? and category = ?  and is_private = 0 ", @uid, :career)
	@personalGoals = Goal.where("user_id = ? and category = ?  and is_private = 0 ", @uid, :personal)
	@physicalGoals = Goal.where("user_id = ? and category = ? and is_private = 0 ", @uid, :physical)
	@socialGoals = Goal.where("user_id = ? and category = ? and is_private = 0 ", @uid, :social)


    @academicPrivateGoals = Goal.where("user_id = ? and category = ? and is_private = 1 ", @uid, :academic)
    @careerPrivateGoals = Goal.where("user_id = ? and category = ?  and is_private = 1 ", @uid, :career)
    @personalPrivateGoals = Goal.where("user_id = ? and category = ?  and is_private = 1 ", @uid, :personal)
    @physicalPrivateGoals = Goal.where("user_id = ? and category = ? and is_private = 1 ", @uid, :physical)
    @socialPrivateGoals = Goal.where("user_id = ? and category = ? and is_private = 1 ", @uid, :social)

    @IleTeams = User.find_by_sql ["select distinct ileteam,section_number from users"]

    @SectionTeams = User.find_by_sql ["select distinct section_number from users group by section_number "]

    @userresult = User.find_by_sql ["
          select COALESCE(round(avg(domainScore),2),-1) as overallScore,u.id,u.name,u.ileteam,u.section_number
          from users u
          left join
          (
            select round(avg(goalScore),4) as domainScore, c.category,c.user_id
            from
            (
              select a.user_id,a.category,a.activetasks, COALESCE(b.completedTasks,0) as completed, ROUND(COALESCE(b.completedTasks,0)*1.00/a.activeTasks*100,4) as goalScore,a.id from
              (
                select count(distinct t.id) as activetasks, g.id,g.category,g.user_id
                from goals g
                join tasks t
                on t.goal_id = g.id
                where 1=1
                and date_part('week',t.due) >= ?
                and date_part('week',t.startdue) <= ?
                and g.is_private = 0
                group by g.id,g.category,g.user_id
              ) a
              left join
              (
                select count(distinct t.id) as completedTasks, g.id,g.category,g.user_id
                from goals g
                join tasks t
                on t.goal_id = g.id
                join tasksprogresses tp
                on tp.task_id = t.id
                where 1=1
                and date_part('week',t.due) >= ?
                and date_part('week',t.startdue) <= ?
                and date_part('week',tp.date) = ?
                and g.is_private = 0
                group by g.id,g.category,g.user_id
              ) b
              on a.id = b.id
            ) c
            group by c.category,c.user_id
          ) d
          on u.id = d.user_id
          group by u.id,u.name,u.ileteam,u.section_number
          order by overallScore desc,u.name asc

            ",@thisWeek,@thisWeek,@thisWeek,@thisWeek,@thisWeek]


  end

end
