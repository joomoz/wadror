class AddProviderToUser < ActiveRecord::Migration
  def change
    add_column :users, :provider, :String
  end
end
