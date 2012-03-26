class ReflectionController < ApplicationController
  def index
	@uid = (params[:u] != nil) ? params[:u] : current_user.id
    @isme = (current_user.id.to_i == @uid.to_i) ? true : false
    @isSaved = (params[:done] != nil) ? true : false
	@questions = ReflectionQuestion.find(:all)
	if @questions.length == 0
		@question = ReflectionQuestion.new(:qno =>'1',:question => 'Why are you at Fuqua? How do you intend to use this experience?  Why did you decide to come to business school and what would be a successful outcome for you at the end of this two-year journey? ', :created_at =>DateTime.now, :updated_at =>DateTime.now)
		@question.save
		@question = ReflectionQuestion.new(:qno =>'2',:question => 'Where are you now? ', :created_at =>DateTime.now, :updated_at =>DateTime.now)
		@question.save
		@question = ReflectionQuestion.new(:qno =>'2a',:question => 'Values: What are your core values?  What is most important to you?  (e.g., people, interests, personal qualities).  List your central/core values (your top 5-8).', :created_at =>DateTime.now, :updated_at =>DateTime.now)
		@question.save
		@question = ReflectionQuestion.new(:qno =>'2b',:question => 'Strengths: What do you believe are some of your personal strengths?  What are the areas you feel confident about or things you feel you contribute to a group?  ', :created_at =>DateTime.now, :updated_at =>DateTime.now)
		@question.save
		@question = ReflectionQuestion.new(:qno =>'2c',:question => 'Weaknesses: What are areas of opportunity that you would like to improve?  These can be specific (e.g., accounting) or more general (i.e., how to engage in difficult conversations with others).  ', :created_at =>DateTime.now, :updated_at =>DateTime.now)
		@question.save
		@question = ReflectionQuestion.new(:qno =>'3',:question => 'Where do you want to be? Describe the person you want to BE, what you need to KNOW and be able to DO, by the end of the Fall terms, upon completion of your first year and upon graduation. ', :created_at =>DateTime.now, :updated_at =>DateTime.now)
		@question.save
	end
	
	@userQuestions = UserReflection.where("user_id = ?", @uid)
		
  end
  
  def new
	@uid = (params[:u] != nil) ? params[:u] : current_user.id
 
	@a2a = params[:ans_2a];
	@a2b = params[:ans_2b];
	@a2c = params[:ans_2c];
	@a3 = params[:ans_3];
	#answer1
	@a1 = params[:ans_1];
	@q = '1'
	if true
		@u11 = UserReflection.where("user_id = ? and question = ?", @uid,@q)
		if @u11.length == 0
			@u1 = UserReflection.new(:user_id=>current_user.id,:question => @q,:answer =>@a1)
			@u1.save
		else
			@u11[0].update_attribute("answer",@a1)
		end
	end
	
	#answer2a
	@a1 = params[:ans_2a];
	@q = '2a'
	if true
		@u11 = UserReflection.where("user_id = ? and question = ?", @uid,@q)
		if @u11.length == 0
			@u1 = UserReflection.new(:user_id=>current_user.id,:question => @q,:answer =>@a1)
			@u1.save
		else
			@u11[0].update_attribute("answer",@a1)
		end
	end
	
	#answer2b
	@a1 = params[:ans_2b];
	@q = '2b'
	if true
		@u11 = UserReflection.where("user_id = ? and question = ?", @uid,@q)
		if @u11.length == 0
			@u1 = UserReflection.new(:user_id=>current_user.id,:question => @q,:answer =>@a1)
			@u1.save
		else
			@u11[0].update_attribute("answer",@a1)
		end
	end
	
	#answer2c
	@a1 = params[:ans_2c];
	@q = '2c'
	if true
		@u11 = UserReflection.where("user_id = ? and question = ?", @uid,@q)
		if @u11.length == 0
			@u1 = UserReflection.new(:user_id=>current_user.id,:question => @q,:answer =>@a1)
			@u1.save
		else
			@u11[0].update_attribute("answer",@a1)
		end
	end
	
	#answer3
	@a1 = params[:ans_3];
	@q = '3'
	if true
		@u11 = UserReflection.where("user_id = ? and question = ?", @uid,@q)
		if @u11.length == 0
			@u1 = UserReflection.new(:user_id=>current_user.id,:question => @q,:answer =>@a1)
			@u1.save
		else
			@u11[0].update_attribute("answer",@a1)
		end
	end
	respond_to do |format|
		format.html { redirect_to reflection_index_url+'?done=1', notice: 'Your Answers were successfully saved.' }
	end
  end
end
