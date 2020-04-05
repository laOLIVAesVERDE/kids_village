class BackFromSchoolsController < ApplicationController


  def create
    @kid = Kid.find(params[:kid_id])
    @facility = Facility.find(params[:facility_id])
    KidMailer.back_from_school(@kid).deliver_now
    if params[:for_kid]
      flash.now[:success] = '保護者に連絡しました'
      render 'kids/after_action_for_kid'
    end
  end
  
end
