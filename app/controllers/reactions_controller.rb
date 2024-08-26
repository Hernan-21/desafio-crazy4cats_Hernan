# app/controllers/reactions_controller.rb
class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @reaction = @post.reactions.find_or_initialize_by(user: current_user)
    @reaction.reaction_type = params[:reaction_type]

    if @reaction.save
      redirect_to @post, notice: 'Tu reacción ha sido registrada.'
    else
      redirect_to @post, alert: 'No se pudo registrar tu reacción.'
    end
  end

  def destroy
    @reaction = @post.reactions.find_by(user: current_user)
    if @reaction&.destroy
      redirect_to @post, notice: 'Tu reacción ha sido eliminada.'
    else
      redirect_to @post, alert: 'No se pudo eliminar tu reacción.'
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
