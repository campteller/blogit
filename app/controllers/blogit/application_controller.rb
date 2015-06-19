module Blogit

  # Inherits from the application's controller instead of ActionController::Base
  class ApplicationController < ::ApplicationController

    helper Blogit::ApplicationHelper, Blogit::LayoutHelper, Blogit::PostsHelper
    
    helper_method :blogit_conf

    # A helper method to access the Blogit::configuration
    # at the class level
    def self.blogit_conf
      Blogit::configuration
    end

    # A helper method to access the Blogit::configuration
    # at the controller instance level
    def blogit_conf
      self.class.blogit_conf
    end

  end
  
end