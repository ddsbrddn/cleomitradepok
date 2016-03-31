class PostsController < ApplicationController
  before_action :authenticate_admin!, except: [:index, :show]
  before_action :require_permission, only: [:edit, :destroy]

  def index
    @posts = Post.all.order('created_at DESC')
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_admin.posts.build(post_params)

    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(params[:post].permit(:title, :body))
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to root_path
  end

  private

    def post_params
      params.require(:post).permit(:title, :body)
    end

    def require_permission
      if current_admin != Post.find(params[:id]).admin
        redirect_to root_path
        flash[:danger] = "Require Permission"
      end
    end
end
