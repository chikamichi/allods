# encoding: UTF-8
module ApplicationHelper
  def admin?
    user_signed_in? && current_user.admin?
  end

  def class_for(resource)
    if owns? resource
      if resource.is_a?(User) || resource.is_a?(Character)
        return 'myself'
      end
    end
    return ''
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

  # Display some resource's attributes as a list.
  #
  # @overload display(method, resource, *args)
  #   the provided method will be applied to the resource to get a list
  #   of attributes.
  #   @param [#to_sym] method
  # @overload display(list, resource, *args)
  #   @param [Array<Symbol>] list
  #
  # @param [Object] resource ActiveModel resource
  # @param [Hash] args
  # @option args [Array<Symbol>] :except ([]) a list of attributes to discard
  # @return [String] the formatted attributes in a <ul> tag
  #
  def display(type, resource, *args)
    opts = {
      :except => []
    }.merge(args.extract_options!)

    model      = resource.class
    attributes = if type.is_a?(Symbol) || type.responds_to?(:to_sym)
                   model.send(type.to_sym)
                 else
                   type
                 end

    unless attributes.nil? || attributes.empty?
      str = '<ul>'
      attributes.each do |attr|
        value = resource.send(attr)
        unless value.blank? || opts[:except].include?(attr)
          str += "<li class='#{attr}'>"
          str += "<span class='attribute #{attr}'>"
          str += t("#{model.to_s.downcase}.attributes.#{attr}")
          str += "</span> : <span>"
          str += format(value, attr, model)
          str += "</span>"
        end
      end
      str += '</ul>'

      return str.html_safe
    else
      return ''
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
  # @param [#to_s] key (nil) key name
  # @param [#to_s] model (nil) model constant
  # @return [String] a formatted version of value
  # @todo add support for a type option to enforce formatting?
  #
  def format(value, key = nil, model = nil)
    $stderr.puts value.inspect
    $stderr.puts key.inspect
    $stderr.puts model.inspect
    if !key.nil?
      if key.to_s.ends_with?('_at')
        l(value.to_date)
      elsif !model.nil?
        t("#{model.to_s.downcase}.#{key}.#{value}", :default => value.to_s)
      else
        value.to_s
      end
    else
      value.to_s
    end
  end

  # 
  def sign_up_in_links(message = nil)
    I18n.translate('.sign_up_in', {
      :sign_up_link => link_to('créer un compte', new_user_registration_url),
      :sign_in_link => link_to('vous connecter', new_user_session_url),
      :message      => message.nil? ? '' : " #{message}"
    }).html_safe
  end
end
