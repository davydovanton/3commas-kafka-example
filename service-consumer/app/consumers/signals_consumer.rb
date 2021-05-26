class SignalsConsumer < ApplicationConsumer
  def consume
    puts '*' * 80

    signals = params_batch.payloads.map { |message| JSON.parse(message)['data'].values }
    sql_signals = signals.map { |signal| "(#{signal.map { |v| "'#{v}'" }.join(', ')})" }.join(', ')

    puts "Signals count: #{signals.count}"

    raw_sql = "INSERT INTO signals VALUES #{sql_signals}"
    $db.execute raw_sql
  end
end
