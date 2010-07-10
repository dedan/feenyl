require'socket.http'
require'ltn12'

-- global data fields
response_body = {}
request_params = "name=admin&pass=hugendubel"
log_file_name = "/var/log/feenyl_remind.log"
log_file, e = io.open(log_file_name, 'a')

socket.http.request{
    url = "http://feenyl.wrfl.de/admin/remind_users?" .. request_params,
    method = "GET",
    sink = ltn12.sink.table(response_body)
}

-- first check for the correct log file
if log_file == nil then
  io.stderr:write("Error feenyl_remind_users: " .. e)
  os.exit(1)
end

for i,v in pairs(response_body) do
   log_file:write(os.date() .. " | ")
   if string.find(v, "SUCCESS") ~= nil then
     log_file:write("Sucessfully reminded users!\n") 
   elseif string.find(v, "NOTHINGTOREMIND") then
     log_file:write("No users to remind!\n")
   else
     log_file:write("Could not remind users!\n")
   end
end
