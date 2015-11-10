$: << "./lib"
require 'XldServer'
require 'rest-client'
require 'xml-object'
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5s', :first_in => 0 do |job|

xld = XldServer.new()
url = "http://#{xld.getHost()}:#{xld.getPort()}/deployit/task/current/all"
resource = RestClient::Resource.new url, {user: xld.getUser(), password: xld.getPassword()}
myObj = XMLObject.new( resource.get )

headers = [{"cols"=>[{"value"=>"Start"}, {"value"=>"Description"}, {"value"=>"State"}]}]
rows = []
begin
   for task in myObj.task
       rows.push( {"cols"=>[{"value"=>task.startDate}, {"value"=>task.description}, {"value"=>task.state2}]} )
   end
rescue
   begin
       task = myObj.task
       rows.push( {"cols"=>[{"value"=>task.startDate}, {"value"=>task.description}, {"value"=>task.state2}]} )
   rescue
       rows.push( {"rowspan"=> 3, "cols"=>[{"value"=>"No Tasks Running"}]} )
   end
end

send_event("xlddata", { hrows: headers, rows: rows } )

end

