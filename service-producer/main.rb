require 'waterdrop'
require 'securerandom'
require 'schema_registry'

require 'water_drop'
require 'water_drop/sync_producer'

WaterDrop.setup do |config|
  config.deliver = true
  config.kafka.seed_brokers = ['kafka://192.168.1.72:9092']
end

event_meta = {
  event_id: SecureRandom.uuid,
  event_version: 1,
  event_time: Time.now.to_s,
  producer: 'producer-service',
  event_name: 'SignalRaised',
}

50.times do
  event_data = {
    strategy_id: SecureRandom.hex(10),
    expirate_at: Time.now.to_s
  }

  event = { **event_meta, data: event_data }
  result = SchemaRegistry.validate_event(event, 'signals.raised', version: 1)

  if result.success?
    pp event
    WaterDrop::SyncProducer.call(event.to_json, topic: 'signals')
  end
end
