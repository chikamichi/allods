class ApplicationController < ActionController::Base
  helper :all

  protect_from_forgery

  # Ensure a user is signed-in and has adminship before proceeding.
  # Otherwise, redirect to the index page with a error message.
  #
  def require_adminship
    unless user_signed_in? && current_user.admin?
      flash[:error] = forbidden!
      redirect_to root_url
    end
  end

  # Defines the locales to be processed while bootstraping the page
  # before rendering.
  PAGE_KEYS = [:title, :hint]

  # Act like a before_render filter. Simple, efficient, robust.
  # No need to hack Rails internals for that matter!
  #
  # Used to boostrap the rendered page config.
  #
  def render(*args)
    bootstrap_page
    super
  end

  # Default, shared URL options, like the server's hostname.
  #
  def default_url_options(options = {})
    {
      :host => MY_DOMAIN
    }
  end

  # @todo: document these ^^
  #
  [:created!, :updated!, :deleted!].each do |method|
    define_method method do
      I18n.t(method.to_s, :scope => [controller_name, :flash])
    end
  end
  def forbidden!
    I18n.t('errors.forbidden')
  end

  # Bootstraps a page, fetching its title and hint. These will not
  # be displayed if their value is missing or set to an empty string
  #
  # To provide a title and/or a hint for a given page, define the locale
  # keys +title+ and +hint+ under the appropriate locale master key,
  # based on the controller/action hierarchy as usual.
  #
  # One may provide interpolation locals by calling +bootstrap_page_with+
  # with the action.
  #
  # @example
  #   def my_action Use-case
  #     # Allow to use locales like:
  #     #   fr.my_controller.my_action.title = "Foo (%{count} items)"
  #     #   fr.my_controller.my_action.hint  = "?%{secret_advise}"
  #     #
  #     bootstrap_page_with :title => {
  #         :count => Foo.count,
  #       },
  #       :hint => {
  #         :secret_advise => " The password is actually #{get_password!}"
  #       }
  #   end
  #
  # @example Useful shortcuts
  #   def my_action
  #     page_title_with :count => Foo.count
  #     page_hint_with  :hint  => " The password is actually #{get_password!}"
  #   end
  #
  def bootstrap_page
    in_current_i18n_scope do
      PAGE_KEYS.each do |key|
        instance_variable_set :"@#{key}", I18n.t(".#{key}", i18n_options_for_page_key(key))
      end
    end
  end

  # Allow to define the interpolations for the current page. Keys should match
  # the PAGE_KEYS, values must be hashes with the interpolations.
  #
  # One may call this method several times in a row, as the interpolations are
  # appended, not erased. Conflicting keys get replaced as one would expect.
  #
  # @param [Hash<Hash>] interpolations
  #
  # @todo: in fact the name sucks. Bootstraping may not be all about handling
  #   interpolations! Gotta find a better DSL.
  #
  def bootstrap_page_with(interpolations)
    interpolations.each do |key, locals|
      page_key_with(key, locals)
    end
  end

  # Dev-friendly shortcut to set title interpolations.
  #
  def title!(locals)
    bootstrap_page_with(:title => locals)
  end

  # Dev-friendly shortcut to set hint interpolations.
  #
  def hint!(locals)
    bootstrap_page_with(:hint => locals)
  end

  # Render a 403 page.
  #
  # @return [File] with status 403 Forbidden
  #
  def render_403
    render :file => "#{Rails.root}/public/403.html", :status => 403 and return
  end

  # Render errors, responding to HTML or JSON. HTTP status is set to 406.
  #
  def render_errors(format, errors)
    format.html { render :template => "shared/errors", :locals => {:errors => errors}, :status => :unprocessable_entity }
    format.json { render :json => errors, :status => :unprocessable_entity }
  end

  private

  # Perform something in a specific I18n scope, enforced by the
  # current controller / action tuple.
  #
  # @yield if a valid scope can be inferred from the current route.
  #
  def in_current_i18n_scope
    if controller_name && action_name
      @@scope = "#{controller_name}.#{action_name}"
      yield
    else
      logger.error "Failed to bootstrap the page given " +
        "controller: #{controller_name.inspect}, action: #{action_name.inspect}"
    end
  end

  # Compiles the I18n options hash required for a page locale, with
  # sensible defaults.
  #
  # @param [Symbol] key
  # @param [Symbol] scope (I18n.locale)
  #
  # @todo: add config.default
  #
  def i18n_options_for_page_key(key, scope = @@scope)
    page_interpolations_for(key).merge!({:scope => scope, :default => ''})
  end

  # Fetch the interpolations for a tuple controller / action / I18n key.
  #
  # @param [Symbol] key
  # @return [Hash]
  #
  def page_interpolations_for(key)
    init_page_interpolations

    cname = controller_name.to_sym
    aname = action_name.to_sym

    if @@page_interpolations.has_key?(cname) &&
       @@page_interpolations[cname].has_key?(aname)
      @@page_interpolations[cname][aname][key] || {}
    else
      {}
    end
  end

  def init_page_interpolations
    @@page_interpolations ||= {}
  end

  def page_key_with(key, locals)
    init_page_interpolations

    cname = controller_name.to_sym
    aname = action_name.to_sym

    return if !locals.is_a?(Hash) || locals.empty?

    # init if needed
    @@page_interpolations.store(cname, {}) unless @@page_interpolations.has_key?(cname)
    @@page_interpolations[cname].store(aname, {}) unless @@page_interpolations[cname].has_key?(aname)

    # then store it
    @@page_interpolations[cname][aname][key] ||= {}
    @@page_interpolations[cname][aname][key].merge!(locals)
  end
end
