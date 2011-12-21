class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :primary_key_trigger => true,
      :comment => "Users of the PHELIX shot database which is used by the Authlogic package" do |t|
      t.string :login, :comment => "login name of the account", :null => false, :limit => 50
      t.string :realname, :comment => "clear name of the user (e.g. Peter Smith)", :null => false, :limit => 50
      t.string :email, :comment => "email adress of the user. Must be valid since password info to sent to it", :null => false
      t.string :crypted_password  
      t.string :password_salt  
      t.string :persistence_token  
      t.timestamps
    end

    add_index :users, :login
    add_index :users, :persistence_token
  end
end
