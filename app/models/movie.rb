class Movie < ActiveRecord::Base

    def self.all_ratings
        rating_list = {}
        self.select(params(:rating)).uniq.each do |tuple|
            rating_list[tuple.rating] = 1
        end
        return rating_list
    end
end
