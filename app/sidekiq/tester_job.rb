class TesterJob
  include Sidekiq::Job

  def perform(*args)
    puts "I'm doing hard work"
  end
end
