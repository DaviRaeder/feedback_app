class Down < ApplicationRecord
  belongs_to :user
  belongs_to :feedback

  validates :user_id, uniqueness: { scope: :feedback_id, message: "Já votou negativo neste feedback" }
end
