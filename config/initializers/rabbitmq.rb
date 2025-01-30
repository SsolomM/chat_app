require "bunny"

module RabbitMQ
  def self.connection
    @connection ||= Bunny.new(
      host: ENV["RABBITMQ_HOST"],
      port: ENV["RABBITMQ_PORT"],
    ).start
  end

  def self.channel
    Thread.current[:rabbitmq_channel] ||= connection.create_channel
  end
end
