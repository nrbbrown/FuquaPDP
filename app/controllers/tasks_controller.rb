class TasksController < ApplicationController

    # PUT /goals/1/tasks/1
    # PUT /goals/1/tasks/1.json
    def update
        puts '--update--'
        is_complete = params[:is_complete]
        @task = Task.find(params[:taskid])
        
        respond_to do |format|
            if @task.update_attribute("is_complete",is_complete)
                format.html { render :nothing => true }
                format.js { render :json => 1}
            else
                format.html { render :nothing => true }
                format.js { render :json => 2 }
            end
        end
    end
    
    
    
end
