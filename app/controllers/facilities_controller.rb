class FacilitiesController < ApplicationController
  before_action :logged_in_user, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def show
    @facility = Facility.find(params[:id])
    @kids = @facility.kids
  end

  def new
    @facility = Facility.new
  end

  def create
    @facility = current_user.facilities.build(facility_params)
    if @facility.save
      flash[:success] = @facility.name + "が追加されました"
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def edit
    @facility = Facility.find(params[:id])
  end

  def update
    @facility = Facility.find(params[:id])
    if @facility.update_attributes(facility_params)
      flash[:success] = "名前を変更しました"
      redirect_to user_path(current_user)
    else
      flash[:danger] = '変更できませんでした'
      render 'edit'
    end
  end

  def destroy
    @facility = Facility.find(params[:id])
    name = @facility.name
    @facility.destroy
    flash[:success] = name + "を削除しました"
    redirect_to user_path(current_user)
  end

  private

    def facility_params
      params.require(:facility).permit(:name)
    end

    def correct_user
      @user = Facility.find(params[:id]).user
      #current_userメソッドの返り値と比較
      redirect_to root_url unless current_user?(@user)
    end

end
