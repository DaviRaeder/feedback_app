class AddFeedbackIdToDowns < ActiveRecord::Migration[7.1]
  def change
    add_reference :downs, :feedback, null: false, foreign_key: true
  end
end
