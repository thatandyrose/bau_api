class CreateRotaAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :rota_assignments do |t|
      t.string :slot
      t.date :date
      t.belongs_to :developer, foreign_key: true

      t.timestamps
    end
  end
end
