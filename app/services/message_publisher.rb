class MessagePublisher
    def self.publish(queue_name, message)
        channel = RabbitMQ.channel
        queue = channel.queue(queue_name, durable: true)
        queue.publish(message.to_json, persistent: true)
    end
end
