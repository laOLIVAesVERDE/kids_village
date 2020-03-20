class FacilitiesController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]

  def show
    @facility = Facility.find(params[:id])
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
end
