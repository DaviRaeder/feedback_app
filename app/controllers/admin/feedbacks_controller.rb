class Admin::FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!

  def index
    @feedbacks = Feedback.all
  
    if params[:query].present?
      query = "%#{params[:query].downcase}%"
      @feedbacks = @feedbacks.where("LOWER(title) LIKE ?", query)
    end
  
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @feedbacks = @feedbacks.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    elsif params[:start_date].present?
      start_date = Date.parse(params[:start_date])
      @feedbacks = @feedbacks.where("created_at >= ?", start_date.beginning_of_day)
    elsif params[:end_date].present?
      end_date = Date.parse(params[:end_date])
      @feedbacks = @feedbacks.where("created_at <= ?", end_date.end_of_day)
    end
  
    @feedbacks = @feedbacks.order(created_at: :desc).page(params[:page]).per(50)
  end  

  def show
  end

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      redirect_to admin_feedbacks_path, notice: 'Feedback criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @feedback.update(feedback_params)
      redirect_to admin_feedback_path(@feedback), notice: 'Feedback atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @feedback.destroy
    redirect_to admin_feedbacks_path, notice: 'Feedback excluído com sucesso.'
  end

  private

  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(:title, :content) # Adicione outros campos necessários
  end

  def authenticate_admin!
    redirect_to root_path, alert: 'Você não tem permissão para acessar esta área.' unless current_user.admin?
  end
end
