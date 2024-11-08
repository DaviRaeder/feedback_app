class HomeController < ApplicationController
  def index
    @feedbacks = Feedback.all.order(created_at: :desc).limit(20)
  end

  def feedbacks
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
  
    @feedbacks = @feedbacks.order(created_at: :desc).page(params[:page]).per(15)
  end
end
