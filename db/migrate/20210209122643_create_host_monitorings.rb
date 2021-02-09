class CreateHostMonitorings < ActiveRecord::Migration[6.1]
  def change
    create_table :host_monitorings do |t|
      t.string :host, index: true, null: false
      t.integer :port, null: false
      t.timestamp :ended_at

      t.timestamps
    end
  end
end
