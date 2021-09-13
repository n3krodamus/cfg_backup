--
--  MAIN
--
local workdir = os.getenv("WORKDIR")
local myfuncs = require (workdir .. "/lua/modules/my_funcs")
local mylogin = require (workdir .. "/lua/modules/my_login")

-- Login
local rc = mylogin.login()
if ( not rc ) then
   print ("Error en login" )
   os.exit()
end


-- Environment settings
local repodir = os.getenv("REPODIR")
if ( not repodir ) then
   print ("Error, no se pudo determinar el repositorio. Falta setear la variable ${REPODIR} en el ambiente")
   os.exit()
end

local start_time = (os.date ("%c")) 
local hubs = myfuncs.get_hubs()
local robots = {}
local probes = {}
local basedir = ""
-- 
local domain = "Domain_Telecom"
local hub_name = SCRIPT_ARGUMENT
local hub_address = "/" .. domain .. "/" .. hub_name


print("Inicio backup sondas " .. os.date ("%c") )

        basedir = repodir .. "/" .. hub_name .. "/" 
        robots = myfuncs.get_hub_robots(hub_address)


        print("-------------------------------------------------")
        print("Domain: " .. domain)
        print("HubName: " .. hub_name)
        print("Dir local: " .. basedir) 
        print("-------------------------------------------------")
        --os.exit()

        if ( robots == "error" or not robots ) then
           print ("No se pudo obtener lista de robots")
        else
           for robot_name, robot_address in pairs(robots) do
              print( "\t" .. robot_name )
              
              --Crear directorio destino
              local robotdir = basedir .. robot_name  
              os.execute(" [ ! -d " .. robotdir .. " ] && " .. " mkdir -p " .. robotdir) 
              print ("\t" .. robotdir )

              probes = myfuncs.get_robot_probes ( robot_address )

              if ( not probes or probes == "error") then
                 print ("\t\tNo se obtuvieron resultados")
              else 


                 for probe_name, probe_value in pairs(probes) do
                   if not ( probe_name == "hdb" or probe_name == "spooler" ) then
                      print ("\t\t" .. probe_name ) 

                      local args = pds.create()
                      pds.putString(args, "directory", probe_value.workdir)
                      pds.putString(args, "file", probe_value.config)
                      pds.putInt(args, "buffer_size", 1000000)

                      --Read config file
                      local configfile, rc = nimbus.request(robot_address, "text_file_get", args)

                      if (rc == 0) then  
                         local d_robot = "controller"
                         local p_args = pds.create()
                         pds.putString(p_args,"directory",robotdir)                         -- Where to write
                         pds.putString(p_args,"file",probe_value.config)                    -- Cfg filename
                         pds.putString(p_args,"file_contents", configfile.file_content)     -- Config data
                         nimbus.request(d_robot,"text_file_put",p_args)                     -- Write to file
                         pds.delete(p_args)
                      else
                         print ("\t\tNo se pudo leer config")
                      end
                      --End config file
                   end
                 end
              end


           end 
end

print("Fin backup " .. os.date ("%c") )
 
