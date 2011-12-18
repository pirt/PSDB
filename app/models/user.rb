class User < ActiveRecord::Base
  acts_as_authentic

  has_many :roles

  def role_symbols
    (roles || []).map {|r| r.title.to_sym}
  end
end
