
class XldEnvironment

   @@maxDeploys = 0

   def initialize()
      @appName = []
   end

   def addApplication( appName )
      @appName.push( appName )
   end

   def setApplications( appNames )
      @appName = appNames
   end

   def getApplications()
      return @appName
   end

   def setMaxDeploys( max )
      @@maxDeploys = max
   end

   def getMaxDeploys()
      return @@maxDeploys
   end

end
