require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req, @res = req, res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "double render" if @already_built_response
    @res.status = 302
    @res.header['location'] = url

    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "double render" if @already_built_response

    @res.write(content)
    @res['Content-Type'] = content_type

    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path = File.dirname(__FILE__)

    temp_name = File.join(
      path,
      "..",
      "views",
      self.class.name.underscore,
      "#{template_name}.html.erb"
    )

    erb_input = File.read(temp_name)

    render_content(
      ERB.new(erb_input).result(binding), "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
    # session_cookie = _rails_lite_app
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
