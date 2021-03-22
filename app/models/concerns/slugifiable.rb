module Slugifiable
    def slug
        slug = username.downcase.strip.gsub(' ', '-')
    end
    module ClassMethods
        def find_by_slug(slug)
            self.all.find {|t| t.slug == slug}
        end
    end
end