class GoalsController < ApplicationController
    
  before_filter :authenticate_user!
    
  # GET /goals
  # GET /goals.json
  def index
    @isedit = false
    @users = User.find(:all,:order=>"name")
		
    @uid = (params[:u] != nil) ? params[:u] : current_user.id
    @isme = (current_user.id.to_i == @uid.to_i) ? true : false
      
    # apply filter
    @filter = params[:filter]
    if @filter == nil then @filter = 'academic' end
    # apply active
    @complete = params[:complete]
    if @complete != '1' && @complete != '0' then @complete = '0' end
      
    # fetch existing
    @goals = Goal.where("user_id = ? and category = ? and is_complete = ?", @uid, @filter, @complete)
    @fullgoals = Goal.where("user_id = ?", @uid);
    
    # new goal
    @goal = Goal.new
    10.times do
        @goal.tasks.build
    end
      
    respond_to do |format|
      format.html # index.html.erb
        format.json { render json: @goals, json: @goal, json: @filter, json: @fullgoals }
    end
  end
    
    # GET /goals/1/edit
    def edit
        @isedit = true
        @users = User.find(:all,:order=>"name")  
        @uid = current_user.id
        
        @goal = Goal.find(params[:id])
        @filter = @goal.category
        @complete = '0'
        
        @goals = Goal.where("user_id = ? and category = ?", current_user.id, @filter)
        @fullgoals = Goal.where("user_id = ?", current_user.id);     
        
        t = 10 - @goal.tasks.length
        
        t.times do
            @goal.tasks.build
        end
        
        respond_to do |format|
            format.html # edit.html.erb
            format.json { render json: @goals, json: @goal, json: @filter, json: @fullgoals }
        end
    end

  # GET /goals/1
  # GET /goals/1.json
  def show
    @goal = Goal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @goal }
    end
  end

  # GET /goals/new
  # GET /goals/new.json
  def new
    @goal = Goal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @goal }
    end
  end

  # POST /goals
  # POST /goals.json
  def create
    @goal = Goal.new(params[:goal])
    
    respond_to do |format|
        # destroy blanx
      if @goal.save
          
          # destroy blank tasks
          blanktasks = Task.where('task = \'\' and goal_id = ?',@goal.id)
          blanktasks.each do |bt|
              bt.destroy
          end
          
        format.html { redirect_to goals_url+'?filter='+@goal.category, notice: 'Your goal was successfully created.' }
        format.json { render json: @goal, status: :created, location: @goal }
      else
        format.html { redirect_to goals_url }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /goals/1
  # PUT /goals/1.json
  def update
    @goal = Goal.find(params[:id])
    is_complete = params[:is_complete]
    
    if(is_complete != nil) # update just complete
        respond_to do |format|
            if @goal.update_attribute("is_complete",is_complete)
                format.html { render :nothing => true }
                format.js { render :json => 1}
                else
                format.html { render :nothing => true }
                format.js { render :json => 2 }
            end
        end
    else # update all
      respond_to do |format|              
          if @goal.update_attributes(params[:goal])
              
            # destroy blank tasks
            blanktasks = Task.where('task = \'\' and goal_id = ?',params[:id])
            blanktasks.each do |bt|
               bt.destroy
            end
            
            format.html { redirect_to goals_url+'?filter='+@goal.category, notice: 'Your goal was successfully updated.' }
            format.json { head :ok }
          else
            format.html { redirect_to goals_url }
            format.json { render json: @goal.errors, status: :unprocessable_entity }
          end
      end
    end
  end
    

  # DELETE /goals/1
  # DELETE /goals/1.json
  def destroy
    @goal = Goal.find(params[:id])
    @filter = @goal.category
      
    @goal.destroy

    respond_to do |format|
      format.html { redirect_to goals_url+'?filter='+@filter }
      format.json { head :ok }
    end
  end

end
