workers_count = ENV["WORKERS_COUNT"].to_i || 1
namespace :jobs do
    desc "Start background job worker"
    task consumers: :environment do
      workers_count.times { Consumers.run }
    end
  end
