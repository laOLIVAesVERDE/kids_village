class KidsController < ApplicationController
  before_action :logged_in_user, only: [:show, :new, :create, :edit, :update, :destroy]

  def show
    @kid = Kid.find(params[:id])
  end

  def new
    @kid = Kid.new
  end

  def create
    facility = Facility.find(params[:facility_id])
    @kid = facility.kids.build(kid_params)
    if @kid.save
      flash[:success] = @kid.name + "さんを追加しました"
      redirect_to facility_path(facility)
    else
      render 'new'
    end
  end

  def edit
    @kid = Kid.find(params[:id])
    @facility = Facility.find(params[:facility_id])
  end

  def update
    @kid = Kid.find(params[:id])
    facility = Facility.find(params[:facility_id])
    if @kid.update_attributes(kid_params)
      flash[:success] = "児童情報を変更しました"
      redirect_to facility_path(facility)
    else
      flash[:danger] = '変更できませんでした'
      render 'edit'
    end
  end

  def destroy
    @kid = Kid.find(params[:id])
    name = @kid.name
    facility = Facility.find(params[:facility_id])
    @kid.destroy
    flash[:success] = name + "さんを削除しました"
    redirect_to facility_path(facility)
  end

  private

    def kid_params
      params.require(:kid).permit(:name, :school, :email, :introduction)
    end


end
