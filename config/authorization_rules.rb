authorization do
  role :admin do
    has_permission_on :experiments, :to => [:index, :show, :new, :create, :edit, :update, :delete]
    has_permission_on :users, :to => [:index, :show, :new, :create, :edit, :update, :delete]
    has_permission_on :authorization_rules, :to => :read
    includes :guest
  end
  role :guest do
    has_permission_on :pages, :to => [:start,:about,:changelog]
  end
end
