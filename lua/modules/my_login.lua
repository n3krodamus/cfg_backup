local my_login = {}

function my_login.login()
   local rc = nimbus.login("user","pass")
   return rc
end

return my_login
