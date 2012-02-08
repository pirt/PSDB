class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # remove uniqueness constraint for email field
    c.validates_uniqueness_of_email_field_options :on => []
  end

  has_many :roles
  has_many :experiment_owners, :dependent => :destroy
  has_many :experiments, :through=> :experiment_owners

  validates :realname, :presence => true,
                       :length => { :maximum => 50 }

  # Do not allow destruction of standard admin 
  before_destroy :check_if_admin_deleted

  # Do not allow change of login field
  before_update :check_if_login_changed

  def role_symbols
    (roles || []).map {|r| r.title.to_sym}
  end

# Return associated roles from a user as a (comma separated) string
  def roles_to_s
    rolesArray=(roles || []).map {|r| r.title}
    return rolesArray.join(sep=$,)
  end

private
  def check_if_admin_deleted
    if (self.login=="admin")
      errors.add(:base, "cannot delete administrator account")
      return false
    else
      return true
    end
  end

  def check_if_login_changed
    if (self.login=="admin" and self.changed? and self.changed.find_index("login")!=nil)
      errors.add(:base, "cannot change login field")
      return false
    else
      return true
    end
  end
end
