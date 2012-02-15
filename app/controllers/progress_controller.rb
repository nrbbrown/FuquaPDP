class ProgressController < ApplicationController

  # GET /progress
  # GET /progress.json
  def index
	  @goal = Goal.find(params[:id])
	  @minDate =  Date.parse(Task.minimum('startdue', :conditions => "goal_id = #{:id}").strftime("%d %b %Y"))
	  @maxDate =  Date.parse(Task.maximum('due', :conditions => "goal_id = #{:id}").strftime("%d %b %Y"))
	  respond_to do |format|
		format.html {render :layout => false} # show.html.erb
      format.json { render json: @goal }
	  end
  end
  
  # GET /progress/new
  # GET /progress/new.json
  def new
	  @task = Task.find(params[:taskid])
	  @dateup = Date.commercial(params[:year].to_i, params[:week].to_i, 1)
	
	  @taskProgress = Tasksprogress.new(:task_id =>params[:taskid],:date =>@dateup, :created_at =>DateTime.now, :updated_at =>DateTime.now)
	  respond_to do |format|
		if @taskProgress.save
			format.html { render :nothing => true }
			format.json { head :ok }
			else
			format.html { render :nothing => true }
			format.json { head :ok }
		end
	  end
  end
end
