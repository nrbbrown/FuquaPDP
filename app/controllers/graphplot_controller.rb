class GraphplotController < ApplicationController
  layout "blank"
  def user
    @graphUser = User.find(params[:id])
    @minDate = Time.zone.today
    @maxDate = Time.zone.today
    @taskStartMin = Task.where(" user_id = ? ",@graphUser.id).minimum('startdue')
    if @taskStartMin != nil
      @minDate =  Date.parse(@taskStartMin.strftime("%d %b %Y"))
    end
    @startWeek = @minDate.cweek
    @endWeek = @maxDate.cweek
    @ccuweek = @startWeek
    @userresult = Hash.new
    while @ccuweek <= @endWeek  do
      @activeT = User.find_by_sql ["
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
                                and g.user_id = ?
                                group by g.id,g.category,g.user_id
                              ) a
                              left join
                              (
                                select count(distinct t.id) completedTasks, g.id,g.category,g.user_id
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
                                and g.user_id = ?
                                group by g.id,g.category,g.user_id
                              ) b
                              on a.id = b.id
                            ) c
                            group by c.category,c.user_id
                          ) d
                          on u.id = d.user_id
                          where u.id = ?
                          group by u.id,u.name,u.ileteam,u.section_number
                          order by overallScore desc
                ",@ccuweek,@ccuweek,@graphUser.id,@ccuweek,@ccuweek,@ccuweek,@graphUser.id,@graphUser.id]

      @userresult[@ccuweek]= @activeT[0].overallscore.to_f


      @ccuweek +=1
    end
  end

  def ileteam
    @graphIle =  params[:id]
    @minDate = Time.zone.today
    @maxDate = Time.zone.today
    @taskStartMinw = Task.find_by_sql ["
                                  select min(startdue) as startdate
                                  from tasks t
                                  join users u
                                  on u.id = t.user_id
                                  where u.ileteam  = ? ",@graphIle]
    @taskStartMin = @taskStartMinw[0].startdate
    if @taskStartMin != nil
     @minDate =  Date.parse(@taskStartMin)
    end
    @startWeek = @minDate.cweek
    @endWeek = @maxDate.cweek
    @ccuweek = @startWeek
    @userresult = Hash.new
    while @ccuweek <= @endWeek  do
      @activeT = User.find_by_sql ["
                    select COALESCE(round(avg(overallScore),2),-1) as overallScore,ileteam,section_number
                    from(
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
                          ) g
                          where ileteam = ?
                          group by ileteam,section_number
                          order by overallScore desc,ileteam asc

                ",@ccuweek,@ccuweek,@ccuweek,@ccuweek,@ccuweek,@graphIle]

      @userresult[@ccuweek]= @activeT[0].overallscore.to_f

      @ccuweek +=1
    end
  end

  def section
    @graphSection =  params[:id]
    @minDate = Time.zone.today
    @maxDate = Time.zone.today
    @taskStartMinw = Task.find_by_sql ["
                                  select min(startdue) as startdate
                                  from tasks t
                                  join users u
                                  on u.id = t.user_id
                                  where u.section_number  = ? ",@graphSection]
    @taskStartMin = @taskStartMinw[0].startdate
    if @taskStartMin != nil
      @minDate =  Date.parse(@taskStartMin)
    end
    @startWeek = @minDate.cweek
    @endWeek = @maxDate.cweek
    @ccuweek = @startWeek
    @userresult = Hash.new
    while @ccuweek <= @endWeek  do
      @activeT = User.find_by_sql ["
                    select COALESCE(round(avg(overallScore),2),-1) as overallScore,section_number
                    from (
                      select COALESCE(round(avg(overallScore),2),-1) as overallScore,ileteam,section_number
                      from(
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
                            ) g
                            group by ileteam,section_number
                    ) h
                    where section_number = ?
                    group by section_number
                    order by overallScore desc,section_number asc


                ",@ccuweek,@ccuweek,@ccuweek,@ccuweek,@ccuweek,@graphSection]

      @userresult[@ccuweek]= @activeT[0].overallscore.to_f

      @ccuweek +=1
    end
  end

end
