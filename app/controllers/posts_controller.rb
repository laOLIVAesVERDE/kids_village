class PostsController < ApplicationController
  before_action :logged_in_user, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def show
    @post = Post.find(params[:id])
    @facility = Facility.find(params[:facility_id])
  end

  def new
    @post = Post.new
  end

  def create
    i = 0
    facility = Facility.find(params[:facility_id])
    @post = facility.posts.build(post_params)
    #post.content.each_char do |c|
    #  i += 1
    #  if i % 40 == 0
    #    post.content.insert(i, "\r\n")
    #  end
    #end
    if @post.save
      flash[:success] = "日記を作成しました"
      redirect_to facility_path(facility)
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
    @facility = Facility.find(params[:facility_id])
  end

  def update
    @post = Post.find(params[:id])
    @facility = Facility.find(params[:facility_id])

    if @post.update_attributes(post_params)
      flash[:success] = "日記を更新しました"
      redirect_to facility_path(@facility)
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    facility = Facility.find(params[:facility_id])
    @post.destroy
    flash[:success] = "日記を削除しました"
    redirect_to facility_path(facility)
  end


  private

    def post_params
      params.require(:post).permit(:title, :content)
    end

    def correct_user
      @user = Post.find(params[:id]).facility.user
      redirect_to root_url unless current_user?(@user)
    end
end
