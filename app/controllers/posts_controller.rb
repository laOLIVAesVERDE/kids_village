class PostsController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def index
    @facility = Facility.find(params[:facility_id])
    @posts = @facility.posts.all.page(params[:pagination_posts]).per(9)

    if params[:for_kid] or request.referer.include?('for_kid')
      render 'index_for_kid'
    end
  end

  def show
    @post = Post.find(params[:id])
    @facility = Facility.find(params[:facility_id])
    if params[:for_kid] or request.referer.include?('for_kid')
      render 'show_for_kid'
    end
  end

  def new
    @facility = Facility.find(params[:facility_id])
    @post = Post.new
    if params[:for_kid] or request.referer.include?('for_kid')
      render 'new_for_kid'
    end
  end

  def create
    @facility = Facility.find(params[:facility_id])
    @post = @facility.posts.build(title: post_params[:title],
                                  content: post_params[:content])
    if @post.save

      if params[:post].has_key?(:kid_ids)
        kid_ids = params[:post][:kid_ids]
        send_mail_after_create_post(kid_ids, @post)
      end


      if params[:for_kid] or request.referer.include?('for_kid')
        flash.now[:success] = "日記を作成しました"
        render 'kids/after_action_for_kid'
      else
        flash[:success] = "日記を作成しました"
        redirect_to facility_path(@facility)
      end
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
      params.require(:post).permit(:title, :content, kid_ids: [])
    end

    def correct_user
      @user = Post.find(params[:id]).facility.user
      redirect_to root_url unless current_user?(@user)
    end

    def send_mail_after_create_post(kid_ids, post)
      kid_ids.each do |kid_id|
        kid = Kid.find_by(id: kid_id)
        PostMailer.create_post(kid, post.content).deliver_now
      end
    end
end
