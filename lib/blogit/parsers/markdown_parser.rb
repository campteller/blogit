class Blogit::Parsers::MarkdownParser
  require "nokogiri"

  # A String containing the content to be parsed
  attr_reader :content

  def initialize(content)
    @content = content
  end

  # The parsed content
  #
  # Returns an HTML safe String
  def parsed
    ensure_pygments_is_installed if Blogit::configuration.highlight_code_syntax
    markdown.render(content).html_safe
  end

  private

    def renderer
      false
    end

    def markdown
      @markdown ||= false
    end

    # Ensures pygments is installed
    #
    # Raises StandardError if pygments is not available on this machine
    def ensure_pygments_is_installed
      warning = <<~WARNING
        [blogit] The pygmentize command could not be found in your load path!
                 Please either do one of the following:

                 $ sudo easy_install Pygments # to install it

                 or

                 set config.highlight_code_syntax to false in your blogit.rb config file.

      WARNING
      raise warning unless which(:pygmentize)
    end

    # Check if an executable exists in the load path
    #
    # Returns nil if no executable is found
    def which(cmd)
      exts = ENV["PATHEXT"] ? ENV["PATHEXT"].split(";") : [""]
      ENV["PATH"].split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable? exe
        end
      end
      nil
    end
end
