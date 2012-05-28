class CommentsController < ApplicationController
  layout "blank"
  def index
	@goal = Goal.find(params[:goalid])
	if params[:taskid].to_i != 0
		@task = Task.find(params[:taskid])
	end
	
	@lastSeen = UserLastSeenComment.where("user_id = ? and goal_id = ? and task_id = ?",current_user.id.to_i,params[:goalid],params[:taskid] )
    if @lastSeen == nil || @lastSeen.length == 0
		@lastSeen = UserLastSeenComment.new(:task_id=>params[:taskid],
										   :goal_id=>params[:goalid],
										   :user_id=>current_user.id.to_i,
										   :last_seen=>Time.now)
		@lastSeen.save
	else
		UserLastSeenComment.update_all(["last_seen = ? ",Time.now],["goal_id = ? and task_id = ? and user_id = ?",params[:goalid],params[:taskid],current_user.id.to_i])
	end
	@goalUser = User.find(params[:goaluserid])
	if params[:goaluserid].to_i == current_user.id.to_i
		UserComments.update_all("is_read = 1",["goal_id = ? and task_id = ? ",params[:goalid],params[:taskid]])
	end
	@comments = UserComments.find_by_sql [" select uc.id, uc.comment_user_id, uc.comment,u.name,uc.created_at 
											from user_comments uc 
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
    if params[:commentid].to_i > 0
		@comment = UserComments.find(params[:commentid])
		if @comment.comment_user_id.to_i == current_user.id.to_i
			@comment.destroy
		end
	else 
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
		UserLastSeenComment.update_all(["last_seen = ? ",Time.now],["goal_id = ? and task_id = ? and user_id = ?",params[:goalid],params[:taskid],current_user.id.to_i])
	end
	@goal = Goal.find(params[:goalid])
	if params[:taskid].to_i != 0
		@task = Task.find(params[:taskid])
	end
	@goalUser = User.find(params[:goaluserid])
	
	@comments = UserComments.find_by_sql [" select uc.id, uc.comment_user_id, uc.comment,u.name,uc.created_at 
											from user_comments uc 
											join users u
											on u.id = uc.comment_user_id
											where uc.goal_id = ?
											and uc.task_id = ?
											order by created_at desc",params[:goalid],params[:taskid]]
											
	render :action => "index"
  end
  
  
end
