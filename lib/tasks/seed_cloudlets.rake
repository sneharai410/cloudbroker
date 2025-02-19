namespace :db do
    desc "Seed Cloudlets into the database"
    task seed_cloudlets: :environment do
      SeedCloudletsJob.perform_now
    end
  end