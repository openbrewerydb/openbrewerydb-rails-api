class CreateAhoyVisitsAndEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :ahoy_visits do |t|
      t.string :visit_token
      t.string :visitor_token

      # standard
      t.string :ip
      t.text :user_agent
      t.text :landing_page

      t.datetime :started_at
    end

    add_index :ahoy_visits, :visit_token, unique: true

    create_table :ahoy_events do |t|
      t.references :visit

      t.string :name
      t.jsonb :properties
      t.datetime :time
    end

    add_index :ahoy_events, [:name, :time]
    add_index :ahoy_events, :properties, using: :gin, opclass: :jsonb_path_ops
  end
end
