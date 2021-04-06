
class Seed
    def self.seed_data
        10.times do
            Tweet.create({content: Faker::TvShows::MichaelScott.quote, author: 'Michael Scott'})
        end

        5.times do
            Tweet.create({content: Faker::Quote.yoda, author: 'Yoda'})
        end

        5.times do
            Tweet.create({content: Faker::Quote.matz, author: 'Matz'})
        end
    end
end
