module ApplicationHelper
  def class_for(resource)
    if owns? resource
      if resource.is_a?(User) || resource.is_a?(Character)
        'myself'
      end
    else
      ''
    end
  end

  # Determines whether the current user owns the specified
  # resource.
  #
  # @param [Object] resource
  # @return [true, false]
  #
  def owns?(resource)
    return false unless user_signed_in?

    if resource.is_a? Character
      return false if resource.user.nil?
      resource.user.id == current_user.id
    end
  end

  # Format an attribute. If the key is provided, the attribute
  # type may be infered for a better guess. In case no smart guess
  # can be made, the value is returned as is.
  #
  # @example With a date
  #
  #   format User.last.created_at, 'created_at'
  #
  # @param [Object] value
  # @param [String] key (nil) key name
  # @return [String] a formatted version of value
  # @todo add support for a type option to enforce formatting?
  #
  def format(value, key = nil)
    if !key.nil?
      if key.ends_with?('_at')
        l(value.to_date)
      else 
        value.to_s
      end
    else
      if value.is_a?(Fixnum) || value.is_a?(Float)
        value.to_s
      else
        value
      end
    end
  end
end
