class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles, :primary_key_trigger => true,
                :comment => "list of roles for authorization" do |t|
      t.column :title, :string
      t.references :user
    end
  end
end
