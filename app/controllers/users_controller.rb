class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end

  def request_friend
    @user = User.find(params[:id])
    @friending_user=User.find(@current_user)
    @friending_user.friend_request(@user)
    redirect_to user_path(@friending_user)
    flash[:noticee]='Your Friend Request Was Sent!'

  end  

  def accept_friend
    @user=User.find(params[:id])
    @friending_user=User.find(@current_user)
    @friending_user.accept_request(@user)
    redirect_to user_path(@friending_user)
  end

  def remove_friend
    @user=User.find(params[:id])
    @friending_user=User.find(@current_user)
    @friending_user.remove_friend(@user)
    redirect_to user_path(@friending_user)
  end

  def user_search
    @users=[]
    @search=params[:search]
    @users=User.where('username LIKE ?',@search+'%')
    @match=User.where('username LIKE ?',@search)
    if @match
      @match.each do |user|
        redirect_to user_path(user.id)
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end



  def user_params
    params.require(:user).permit(:username, :email,:password,
                                 :password_confirmation,:requested_friends,:pending_friends,
                                 :friends,:avatar,:about)
  end
end
