class CreateAhoyVisitsAndEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :ahoy_visits do |t|
      t.string :visit_token
      t.string :visitor_token
      t.timestamp :started_at
    end

    add_index :ahoy_visits, [:visit_token], unique: true

    create_table :ahoy_events do |t|
      t.references :visit
      t.string :name
      t.jsonb :properties
      t.timestamp :time
    end

    add_index :ahoy_events, [:name, :time]
    add_index :ahoy_events, "properties jsonb_path_ops", using: "gin"
  end
end
