$: << "./lib"
require 'XldEnvironment'
require 'XldServer'
require 'rest-client'
require 'xml-object'
lastNumberOfEnvironments = 0
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5s', :first_in => 0 do |job|

def getEnvironments()
   xld = XldServer.new()
   url = "http://#{xld.getHost()}:#{xld.getPort()}/deployit/repository/query?type=udm.Environment"
   resource = RestClient::Resource.new url, {user: xld.getUser(), password: xld.getPassword()}
   myObj = XMLObject.new( resource.get )

   numberOfEnvironments = myObj.ci.size
   env = Hash.new()
   begin
      for ci in myObj.ci
          myEnv = XldEnvironment.new()
          #env[ci.ref] = myEnv
          envName = ci.ref.gsub(/Env.*\//,'')
          env[envName] = myEnv
      end
   rescue
      begin
          myEnv = XldEnvironment.new()
          #env[ci.ref] = myEnv
          envName = ci.ref.gsub(/Env.*\//,'')
          env[envName] = myEnv
      rescue
          ci = ""
          puts "Env Errors"
      end
   end
   url = "http://#{xld.getHost()}:#{xld.getPort()}/deployit/repository/query?type=udm.DeployedApplication"
   appResource = RestClient::Resource.new url, {user: xld.getUser(), password: xld.getPassword()}
   myDepApp = XMLObject.new( appResource.get )
   begin
      for app in myDepApp.ci
         myApp = Applications( app.ref )
         #env[myApp.environment.ref].addApplication( app.ref )
         envName = myApp.environment.ref.gsub(/Env.*\//,'')
         env[envName].addApplication( app.ref )
      end
   rescue
      puts "Problem"
   end
   for envName, envObj in env
      deploys = envObj.getApplications().size
      if ( deploys > envObj.getMaxDeploys() )
          envObj.setMaxDeploys( deploys )
      end
   end
   return env
end

def Applications( appName )
   xld = XldServer.new()
   url = "http://#{xld.getHost()}:#{xld.getPort()}/deployit/repository/ci/#{appName}"
   resource = RestClient::Resource.new url, {user: xld.getUser(), password: xld.getPassword()}
   myApp = XMLObject.new( resource.get )
   return myApp
end

env = getEnvironments()
numberOfEnvironments = env.size
lastNumberOfEnvironments = numberOfEnvironments
puts "Number of Environments = #{numberOfEnvironments}"

for envName, envObj in env
   deploys = envObj.getApplications().size
   puts "Env = #{envName} Deploys = #{deploys} / #{envObj.getMaxDeploys()}"
   send_event(envName, { value: deploys, max: envObj.getMaxDeploys() })
end
send_event('allenvs', { current: numberOfEnvironments, last: lastNumberOfEnvironments })

end

