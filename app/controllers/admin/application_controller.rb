module Admin
  class ApplicationController < ::ApplicationController
    before_action :authenticate_admin!

    private

    def authenticate_admin!
      redirect_to root_path, alert: 'Você não tem permissão para acessar esta área.' unless current_user&.admin?
    end
  end
end