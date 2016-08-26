module Authorization
  def require!(message)
    method_name = message.to_s
    method_name = method_name.sub(/^can_/, '')
    method_name += '?'

    if !can(method_name)
      raise Authorization::Error.new("Current user does not have permissions: #{message}")
    end
  end

  def can(method_name)
    role.send(method_name)
  end

  def role
    @role ||= Role.new(current_user)
  end

  class Error < SecurityError
  end
end
