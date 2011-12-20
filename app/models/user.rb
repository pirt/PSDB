class User < ActiveRecord::Base
  acts_as_authentic

  has_many :roles

  def role_symbols
    (roles || []).map {|r| r.title.to_sym}
  end

# Return associated roles from a user as a (comma separated) string
  def roles_to_s
    rolesArray=(roles || []).map {|r| r.title}
    return rolesArray.join(sep=$,)
  end
end
