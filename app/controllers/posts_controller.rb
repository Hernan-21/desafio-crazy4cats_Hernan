# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: 'Post creado exitosamente.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post actualizado exitosamente.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post eliminado exitosamente.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end

# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:create]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user unless params[:anonymous]

    if @comment.save
      redirect_to @post, notice: 'Comentario añadido exitosamente.'
    else
      redirect_to @post, alert: 'Error al añadir el comentario.'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to @comment.post, notice: 'Comentario eliminado exitosamente.'
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end

# app/controllers/reactions_controller.rb
class ReactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @reaction = @post.reactions.find_or_initialize_by(user: current_user)
    @reaction.reaction_type = params[:reaction_type]

    if @reaction.save
      redirect_to @post, notice: 'Reacción registrada.'
    else
      redirect_to @post, alert: 'No se pudo registrar la reacción.'
    end
  end

  def destroy
    @reaction = current_user.reactions.find(params[:id])
    @reaction.destroy
    redirect_to @reaction.post, notice: 'Reacción eliminada.'
  end
end
