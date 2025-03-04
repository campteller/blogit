module Blogit
  module Parsers
    class TextileParser

      # A String containing the content to be parsed
      attr_reader :content

      def initialize(content)
        @content = content
      end

      # The parsed content
      #
      # Returns an HTML safe String
      def parsed
        content.html_safe
      end
    end
  end
end
