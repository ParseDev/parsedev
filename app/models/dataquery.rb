class Dataquery < ApplicationRecord
    belongs_to :user
    belongs_to :datasource

    def sanitized_query
        query.gsub(/(sk_live_)[a-zA-Z0-9]+/, '\1***********').strip
    end
end
