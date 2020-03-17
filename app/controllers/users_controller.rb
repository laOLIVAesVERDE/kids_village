class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:show, :edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Kids Villageへようこそ"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    #管理者として更新されないよう、ストロングパラメータを使って制限
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password,
                                   :password_confirmation,
                                   :image)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = 'アクセスするにはログインしてください'
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      #current_userメソッドの返り値と比較
      redirect_to root_url unless current_user?(@user)
    end

end
