class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :primary_key_trigger => true,
      :comment => "Users of the PHELIX shot database which is used by the Authlogic package" do |t|
      t.string :username  
      t.string :email  
      t.string :crypted_password  
      t.string :password_salt  
      t.string :persistence_token  
      t.timestamps
    end

    add_index :users, :username
    add_index :users, :persistence_token
  end
end
