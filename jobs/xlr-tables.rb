$: << "./lib"
require 'XlrServer'
require 'json'
require 'rest-client'
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5s', :first_in => 0 do |job|

xlr = XlrServer.new()
url = "http://#{xlr.getHost()}:#{xlr.getPort()}/api/v1/releases/"
resource = RestClient::Resource.new url, {user: xlr.getUser(), password: xlr.getPassword()}

myRel = JSON.parse( resource.get )

headers = [{"cols"=>[{"value"=>"Start"}, {"value"=>"Description"}, {"value"=>"State"}]}]
rows = []
begin
   for rel in myRel
       if( rel['status'] != 'TEMPLATE' and rel['status'] != 'PLANNED' )
          rows.push( {"cols"=>[{"value"=> rel['startDate'] }, {"value"=> rel['title'] }, {"value"=> rel['status'] }]} )
       end
   end
rescue
   begin
          rel = myRel
          rows.push( {"cols"=>[{"value"=> rel['startDate'] }, {"value"=> rel['title'] }, {"value"=> rel['status'] }]} )
   rescue
       rows.push( {"rowspan"=> 3, "cols"=>[{"value"=>"No Tasks Running"}]} )
   end
end

send_event("xlrdata", { hrows: headers, rows: rows } )

end

