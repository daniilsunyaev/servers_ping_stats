class CreatePingResults < ActiveRecord::Migration[6.1]
  def change
    create_table :ping_results do |t|
      t.string :host, null: false
      t.integer :port, null: false
      t.float :duration
      t.string :error
      t.string :warning

      t.timestamps
    end

    add_index :ping_results, [:host, :port]
    add_index :ping_results, :created_at, using: :brin
  end
end
