class CreateFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :feedbacks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :rating

      t.timestamps
    end
  end
end
