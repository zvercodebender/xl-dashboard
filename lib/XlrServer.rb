
class XlrServer

    @@host = "localhost"
    @@port = "5516"
    @@user = "admin"
    @@pass = "admin"

   def getHost()
      return @@host
   end

   def getPort()
      return @@port
   end

   def getUser()
      return @@user
   end

   def getPassword()
      return @@pass
   end

end
