class UsersController < ApplicationController
  # My Portfolio (Profile Page)
  def my_portfolio
    @user = current_user
    @user_stocks = current_user.stocks
  end
  
  # List Friends with Actions
  def my_friends
    @friendships = current_user.friends
  end
  
  # Show Profile
  def show
    @user = User.find(params[:id])
    @user_stocks = @user.stocks
  end
  
  # Adds friendship relation with selected friend to current_user
  def add_friend
    @friend = User.find(params[:friend]) # Finds the user object of the friend from the list.
    current_user.friendships.build(friend_id: @friend.id) # Builds the relationship
    
    if current_user.save
      flash[:success] = "Friend was successfully added"
    else
      flash[:danger] = "There was something wrong with the friend request"
    end
    redirect_to my_friends_path
  end
  
  # Remove Friends
  def destroy
    
  end
  
  # Search for friends
  def search
    if params[:search_param].blank? # Check if text entry is blank
      flash.now[:danger] = "You've entered an empty search string" # Render message to user
    else
      @users = User.search(params[:search_param]) # Search for user
      @users = current_user.except_current_users(@users) # Remove Current User from the results
      flash.now[:danger] = "No users match this search criteria" if @users.blank? # If no users are returned render message to user
    end
    respond_to do |format|
      format.js { render partial: 'friends/result' } #Render Java Script partial (limits page reloads and get requests)
    end
  end
end