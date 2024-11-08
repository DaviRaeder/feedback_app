class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    if params[:query].present? || params[:role].present?
      if params[:role].present?
        role = User.roles[params[:role].downcase.to_sym]
        @users = User.where(role: role) if role
      else
        query = "%#{params[:query].downcase}%"
        @users = User.where("LOWER(email) LIKE ?", query)
      end
    else
      @users = User.all
    end
  
    @users = @users.order(created_at: :desc).page(params[:page]).per(50)
  end  

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'Usuário atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: 'Usuário excluído com sucesso.'
  end  

  private

  def user_params
    params.require(:user).permit(:email, :role)
  end

  def check_admin
    redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?
  end
end
