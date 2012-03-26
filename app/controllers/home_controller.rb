class HomeController < ApplicationController


  def index
    @users = User.all

    @fail = params[:f]
      
    respond_to do |format|
          # redirect?
          if user_signed_in?
              format.html { redirect_to goals_url }
          elsif @fail == '1'
              flash.alert = 'Invalid email or password.'
              format.html
          else
              format.html
          end
     end
  end
    

end
