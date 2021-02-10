class DropPortConstraints < ActiveRecord::Migration[6.1]
  def change
    change_column_null :host_monitorings, :port, from: false, to: true
    change_column_null :ping_results, :port, from: false, to: true
  end
end
