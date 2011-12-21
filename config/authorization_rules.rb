authorization do
  role :admin do
    has_omnipotence
  end
  role :experimentalist do
    has_permission_on :experiments, :to => :read
 
   # has_permission_on :experiments, :to => :show do
   #   if_attribute :users => contains {user}
   # end

    has_permission_on :authorization_usages, :to => :read
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
