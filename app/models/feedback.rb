class Feedback < ApplicationRecord
  belongs_to :user

  has_many :ups, dependent: :destroy
  has_many :downs, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :rating, inclusion: { in: 1..5 }
end
