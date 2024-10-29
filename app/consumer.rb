require 'amqp-client'
require 'dotenv/load'

# Opens and establishes a connection, channel is created automatically
ampq_uri = "amqp://#{ENV['RABBITMQ_USER']}:#{ENV['RABBITMQ_PASSWORD']}@#{ENV['RABBITMQ_HOST']}:#{ENV['RABBITMQ_PORT']}/#{ENV['RABBITMQ_VHOST']}"
puts ampq_uri
client = AMQP::Client.new(ampq_uri).start

# Declare a queue
queue = client.queue 'email.notifications'

counter = 0
# Subscribe to the queue
queue.subscribe do |msg|
  counter += 1
  # Add logic to handle the message here...
  puts "[📤] Message received [#{counter}]: #{msg.body}"
  # Acknowledge the message
  msg.ack
rescue StandardError => e
  puts e.full_message
  msg.reject(requeue: false)
end

# Close the connection when the script exits
at_exit do
  client.stop
  puts '[❎] Connection closed'
end

# Keep the consumer running
sleep
