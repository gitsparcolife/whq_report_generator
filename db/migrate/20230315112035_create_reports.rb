class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.string :name
      t.string :link
      t.json :dim_score
      t.string :email
      t.date :date

      t.timestamps
    end
  end
end
