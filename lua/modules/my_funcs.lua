local my_funcs = {}


function my_funcs.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end



-- Get Hubs
function my_funcs.get_hubs()
        local hubs = {}
        local gethubs = nimbus.request("hub","gethubs")
        for row,hub in pairs(gethubs.hublist) do
                hubs[hub.name] = hub.addr
        end
        return hubs
end


-- Get robots from hub
function my_funcs.get_hub_robots(hub_address)
        local robots = {}
        getrobots, rc = nimbus.request(hub_address, "getrobots")
        if (rc ~= 0) then
                return "error"
        end

        for x, robot in pairs(getrobots.robotlist) do
                if (robot.status == 0) then
                        robots[robot.name] = robot.addr
                end
        end
        return (robots)
end

-- Get probes from robot
function my_funcs.get_robot_probes(robot_address)
        local getprobes = {}
        getprobes, rc = nimbus.request(robot_address .. "/controller", "probe_list", "", 300)

        if rc ~= 0 then
           return "error"
        else
           return (getprobes)
        end
end

return my_funcs
