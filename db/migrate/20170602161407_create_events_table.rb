class CreateEventsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :action, null: false
      t.string :data, null: false
    end
  end
end
