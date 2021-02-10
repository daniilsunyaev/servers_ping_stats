class RemovePortColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :host_monitorings, :port
    remove_index :ping_results, name: 'index_ping_results_on_host_and_port'
    remove_column :ping_results, :port
    add_index :ping_results, :host
  end
end
