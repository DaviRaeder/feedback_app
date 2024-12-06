class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, admin: 1 }

  has_many :feedbacks, dependent: :destroy
  has_many :ups, dependent: :destroy
  has_many :downs, dependent: :destroy

  def add_up(feedback)
    puts "Adicionando UP para o feedback ##{feedback.id}"
    puts "Removendo downs..."
    downs.where(feedback: feedback).destroy_all
    puts "Criando UP..."
    ups.find_or_create_by!(feedback: feedback)
    puts "UP criado com sucesso"
  end
  
  def add_down(feedback)
    puts "Adicionando DOWN para o feedback ##{feedback.id}"
    transaction do
      puts "Removendo ups..."
      ups.where(feedback: feedback).destroy_all
      puts "Criando DOWN..."
      downs.find_or_create_by!(feedback: feedback)
    end
    puts "DOWN criado com sucesso"
  rescue => e
    Rails.logger.error "Erro ao adicionar DOWN: #{e.message}"
  end  

  def voted_up?(feedback)
    ups.exists?(feedback: feedback)
  end

  def voted_down?(feedback)
    downs.exists?(feedback: feedback)
  end
end
