class CommentsController < ApplicationController
  layout "blank"
  def index
	@goal = Goal.find(params[:goalid])
	@task = Task.find(params[:taskid])
	@goalUser = User.find(params[:goaluserid])
	if params[:goaluserid].to_i == current_user.id.to_i
		UserComments.update_all("is_read = 1",["goal_id = ? and task_id = ? ",params[:goalid],params[:taskid]])
	end
	@comments = UserComments.find_by_sql [" select uc.comment,u.name,uc.created_at 
											from user_comments uc (nolock)
											join users u
											on u.id = uc.comment_user_id
											where uc.goal_id = ?
											and uc.task_id = ?
											order by created_at desc ",params[:goalid],params[:taskid]]
	
	respond_to do |format|
      format.html 
    end
  end
  
  def edit
    @is_read = 0;
	if params[:goaluserid].to_i == current_user.id.to_i
		@is_read = 1;
	end
	if params[:comment].strip != ''
	@newComment = UserComments.new(:task_id=>params[:taskid],
								   :goal_id=>params[:goalid],
								   :goal_user_id=>params[:goaluserid],
								   :comment_user_id=>current_user.id.to_i,
								   :comment=>params[:comment],
								   :created_at=>Time.now.getlocal,
								   :is_read=>@is_read)
	@newComment.save
	end
	@goal = Goal.find(params[:goalid])
	@task = Task.find(params[:taskid])
	@goalUser = User.find(params[:goaluserid])
	
	@comments = UserComments.find_by_sql [" select uc.comment,u.name,uc.created_at 
											from user_comments uc (nolock)
											join users u
											on u.id = uc.comment_user_id
											where uc.goal_id = ?
											and uc.task_id = ?
											order by created_at desc",params[:goalid],params[:taskid]]
											
	render :action => "index"
  end
end
