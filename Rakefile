task :environment do
  require_relative "./config/environment.rb"
end

task :console => :environment do
  Pry.start
end

task :seed => :environment do
  Seed.seed_data
end
