module Blogit
  class Post < ApplicationRecord
    require "kaminari"

    paginates_per(Blogit.configuration.posts_per_page)

    # ===============
    # = Validations =
    # ===============

    validates :title, presence: true, length: { minimum: 10, maximum: 66 }

    validates :body,  presence: true, length: { minimum: 10 }

    validates :description, presence: Blogit.configuration.show_post_description

    validates :state, presence: true

    # ================
    # = Associations =
    # ================

    ##
    # The {Comment Comments} written on this Post
    #
    # Returns an ActiveRecord::Relation instance
    has_many :comments, class_name: "Blogit::Comment"

    has_one_attached :image, dependent: :destroy

    has_rich_text :body
    has_rich_text :description

    # ==========
    # = Scopes =
    # ==========

    scope :for_index, lambda { |page_no = 1|
                        active.order("created_at DESC").page(page_no)
                      }

    scope :active, lambda { where(state:  Blogit.configuration.active_states) }

    # The posts to be displayed for RSS and XML feeds/sitemaps
    #
    # Returns an ActiveRecord::Relation
    def self.for_feed
      active.order("created_at DESC")
    end

    # Finds an active post with given id
    #
    # id - The id of the Post to find
    #
    # Returns a Blogit::Post
    # Raises ActiveRecord::NoMethodError if no Blogit::Post could be found
    def self.active_with_id(id)
      active.find(id)
    end

    # ====================
    # = Instance Methods =
    # ====================

    # TODO: Get published at working properly!
    def published_at
      created_at
    end

    def to_param
      "#{id}-#{title.parameterize}"
    end

    # The content of the Post to be shown in the RSS feed.
    #
    # Returns description when Blogit.configuration.show_post_description is true
    # Returns body when Blogit.configuration.show_post_description is false
    def short_body
      if Blogit.configuration.show_post_description
        description
      else
        body
      end
    end

    def comments
      check_comments_config
      super()
    end

    def comments=(value)
      check_comments_config
      super(value)
    end

    private

      def check_comments_config
        unless Blogit.configuration.include_comments == :active_record
          raise "Posts only allow active record comments (check blogit configuration)"
        end
      end
  end
end
