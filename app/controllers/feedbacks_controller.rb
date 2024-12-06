class FeedbacksController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_feedback, only: [:edit, :update, :destroy]
  before_action :authorize_feedback!, only: [:edit, :update, :destroy]
  before_action :vote_or_downvote_feedback!, only: [:upvote, :downvote]
  before_action :set_feedback, only: [:upvote, :downvote]

  def show
    @feedback = Feedback.find(params[:id])
  end

  def new
    @feedback = Feedback.new
  end

  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  def create
    @feedback = current_user.feedbacks.build(feedback_params)
    if @feedback.save
      redirect_to @feedback, notice: 'Feedback criado com sucesso.'
    else
      render :new
    end
  end

  def upvote
    @feedback = Feedback.find(params[:id])
  
    if Up.exists?(feedback: @feedback, user: current_user)
      @feedback.ups.find_by(user: current_user).destroy
      render json: { ups_count: @feedback.ups.count, downs_count: @feedback.downs.count }, status: :ok
      return
    end
  
    if Down.exists?(feedback: @feedback, user: current_user)
      @feedback.downs.find_by(user: current_user).destroy
    end
  
    up = @feedback.ups.build(user: current_user)
  
    if up.save
      render json: { ups_count: @feedback.ups.count, downs_count: @feedback.downs.count }, status: :ok
    else
      render json: { error: "Erro ao salvar o voto para cima" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Feedback não encontrado" }, status: :not_found
  end
  
  def downvote
    @feedback = Feedback.find(params[:id])

    if Down.exists?(feedback: @feedback, user: current_user)
      @feedback.downs.find_by(user: current_user).destroy
      render json: { ups_count: @feedback.ups.count, downs_count: @feedback.downs.count }, status: :ok
      return
    end
  
    if Up.exists?(feedback: @feedback, user: current_user)
      @feedback.ups.find_by(user: current_user).destroy
    end
  
    down = @feedback.downs.build(user: current_user)
  
    if down.save
      render json: { ups_count: @feedback.ups.count, downs_count: @feedback.downs.count }, status: :ok
    else
      render json: { error: "Erro ao salvar o voto para baixo" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Feedback não encontrado" }, status: :not_found
  end

  def edit
    @feedback = Feedback.find(params[:id])
  end

  def update
    @feedback = Feedback.find(params[:id])
    if @feedback.update(feedback_params)
      redirect_to @feedback, notice: 'Feedback atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy
    redirect_to feedbacks_path, notice: 'Feedback excluído com sucesso.'
  end

  private

  def feedback_params
    params.require(:feedback).permit(:title, :description, :rating)
  end

  def authorize_feedback!
    @feedback = Feedback.find(params[:id])
    redirect_to feedbacks_path, alert: 'Você não tem permissão para acessar este feedback.' unless @feedback.user_id == current_user.id
  end

  def vote_or_downvote_feedback!
    @feedback = Feedback.find(params[:id])
    redirect_to feedbacks_path, alert: 'Você não tem permissão para votar neste feedback.' unless @feedback.user_id != current_user.id
  end

  def set_feedback
    @feedback = Feedback.find(params[:id])
  end
end
