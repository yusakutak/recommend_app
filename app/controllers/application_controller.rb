class ApplicationController < ActionController::Base
 def hello
    render html: "Hello, world!"
 end

 def after_sign_in_path_for(resource)
  form_path
 end

 def after_sign_up_path_for(resource)
  form_path
 end
end
