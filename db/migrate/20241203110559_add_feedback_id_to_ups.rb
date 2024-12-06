class AddFeedbackIdToUps < ActiveRecord::Migration[7.1]
  def change
    add_reference :ups, :feedback, null: false, foreign_key: true
  end
end
