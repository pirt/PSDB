authorization do
  role :admin do
    has_permission_on :experiments, :to => [:index, :show, :new, :create, :edit, :update, :delete]
    includes :guest
  end
  role :guest do
    has_permission_on :authorization_rules, :to => :read
    has_permission_on :pages, :to => :start
  end
end
