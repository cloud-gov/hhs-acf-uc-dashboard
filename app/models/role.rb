class Role
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def delegate_object
    @delegate_object ||= role_class.new
  end

  delegate :manage_users?, :name,
    to: :delegate_object

  private

  def role_class
    return Role::None if !user
    type_map[user.role.to_s.underscore.to_sym] || Role::None
  end

  def type_map
    {
      admin: ::Role::AdminRole,
      operations: Role::Operations,
      general: Role::General,
    }
  end
end
