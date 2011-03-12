class ActiveRecord::Base        
  # Filter out attributes based on explicit, simple rules. This
  # defines helper *_attributes methods on model objects.
  #
  # @param [Hash] the filters, see example for details
  #
  # @example
  #
  #   # in app/model/foo.rb
  #   class Foo < ActiveRecord::Base
  #     expose_attributes :public   => [:login, :address, :description],
  #                       :editable => [:address, :description, :password]
  #   end
  #
  #   # now one can make use of:
  #   Foo.first.public_attributes
  #   Foo.first.editable_attributes # useful to iterate over in _form partials, for instance
  #   Foo.first.editable_attribute? :description # => true
  #   Foo.editable_attributes # => [:address, :description, :password] in order
  #
  # @todo: turn this into a little gem, and add support for simple options (prefix [String, nil],
  #   maybe the ability to define a proc to be used as the method implementation!).
  #   Change a little bit the DSL to ease things out:
  #
  #   @example TODO
  #     expose_attributes :public,  :suffix => 'keys', :login, :address, :description
  #     expose_attributes :public,  :suffix => nil, :login, :address, :description
  #     expose_attributes :private, :do => proc { |model| model.attributes.keep_if { |a| a.to_s.match? /_private$/ } }
  #     expose_attributes :private, :do => :filter_private_attributes # call this method, cleaner
  #
  def self.expose_attributes(*args)
    args.first.each do |name, exposed|
      define_method :"#{name}_attributes" do
        attributes.keep_if { |a| exposed.include?(a.to_sym) }
      end

      define_method :"#{name}_attribute?" do |attribute|
        !!self.send(:"#{name}_attributes").include?(attribute.to_s)
      end

      self.metaclass.send :define_method, :"#{name}_attributes" do
        exposed
      end
    end
  end

  # @todo: use my Logg gem once published! :D
  #
  def log_event(event, metadata = nil, object = nil)
    message = log_message(event, metadata, object)
    logger.debug "#{Time.now} | #{message}" unless message.nil?
  end
end
