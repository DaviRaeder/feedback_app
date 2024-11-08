class FeedbacksController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_feedback, only: [:edit, :update, :destroy]
  before_action :authorize_feedback!, only: [:edit, :update, :destroy]

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
    redirect_to feedbacks_path, alert: 'Você não tem permissão para acessar este feedback.' unless @feedback.user_id == current_user.id
  end
end
