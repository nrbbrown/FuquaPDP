class ProgressController < ApplicationController

# GET /goals
  # GET /goals.json
  def index
  @goal = Goal.find(params[:id])
  @minDate =  Date.parse(Task.minimum('startdue', :conditions => "goal_id = #{:id}").strftime("%d %b %Y"))
  @maxDate =  Date.parse(Task.maximum('due', :conditions => "goal_id = #{:id}").strftime("%d %b %Y"))
  end
end
