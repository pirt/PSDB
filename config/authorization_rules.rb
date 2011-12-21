authorization do
  role :admin do
    has_permission_on :experiments, :to => :manage
    has_permission_on :users, :to => :manage
    has_permission_on :authorization_rules, :to => :read
    includes :guest
  end
  role :experimentalist do
    has_permission_on :experiments, :to => :read
    includes :guest
  end

  role :guest do
    has_permission_on :pages, :to => [:start,:about,:changelog]
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
