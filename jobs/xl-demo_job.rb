require 'time'
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5s', :first_in => 0 do |job|
  send_event('karma', { current: rand(1000) })
  myVal = rand(100)
  myMax = rand(30) + 70
  myVal = 50
  puts " #{myVal} / #{myMax} "
  send_event('envdep',   { value: myVal, max: myMax })
  x = Time.now.utc.iso8601
  myMsg = "#{$LOAD_PATH}"

  send_event('message', { text: myMsg })
end
