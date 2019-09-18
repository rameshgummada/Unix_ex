#REQUIRE:download_cells.py
#Script is used to output where the logs are located for each server
resource = '/home/rameshgummada/PYTHON_SCRIPTS'
import sys
import re
sys.path.insert(0, resource)
from select_cells import SelectCells
from log_report import LogReport
from html_render import RenderHTML

#Grab the list of servers to run
app = sys.argv[1] #PROJECT/B2B
env_type = sys.argv[2] #NONPROD/PROD
env = sys.argv[3] #DEV/FT
version = sys.argv[4] #U8/U7
html_loc = sys.argv[5] #html file path
log_loc = sys.argv[6] #log file path
servers = SelectCells.getServers(SelectCells(),app, env_type, env, version)
log = LogReport(log_loc)
html = RenderHTML(html_loc)
html.head("Log Locationss", servers[0]["V"], html_loc)

html.tableStart("Log Locations")
html.tableHeaders(["ENV","CELL","SERVER","V","SystemOut Location", "SystemError Location", "STDOut Location", "STDErr Location"])

if env_type == "NONPROD":
        root_loc = "/home/rameshgummada/PYTHON_SCRIPTS"
else:
        root_loc = "/home/rameshgummada/PYTHON_SCRIPTS"
for server in servers:
        if not server["SERVER"] == "dmgr":
                try:
                        vars = ''
                        var_file = open(root_loc + server["V"] + "/" + server["HOST"] + "/" + server["CELL"] + "/" + server["SERVER"] + "/SERVER/variables.xml")
                        for line in var_file:
                                vars += line
                        var_file.close()
                        server_loc = re.findall('SERVER_LOG_ROOT"\s+value="(.+)" description',vars)
                        if len(server_loc) == 0:
                                server_loc = ["N\A"]

                        serv = ''
                        server_file = open(root_loc + server["V"] + "/" + server["HOST"] + "/" + server["CELL"] + "/" + server["SERVER"] + "/SERVER/server.xml")
                        for line in server_file:
                                serv += line
                        server_file.close()
                        system_out = re.findall('fileName="(.+SystemOut.log)',serv)
                        system_err = re.findall('fileName="(.+SystemErr.log)',serv)
                        stdPath = re.findall('stdoutFilename="(.+)"\sstderrFilename="(.+)"/>',serv)
                        if len(system_out) == 0:
                                system_out = ["N\A"]
                        if len(system_err) == 0:
                                system_err = ["N\A"]
                        if len(stdPath) == 0:
                                stdPath = [["N\A","N\A"]]
                        stdout = str(stdPath[0][0]).replace("${PROJECT_SERVER_LOG_ROOT}", server_loc[0]).replace("${SERVER_LOG_ROOT}", server_loc[0]).replace("${WAS_SERVER_NAME}", "").replace("${LOG_ROOT}", "")
                        stderr = stdPath[0][1].replace("${PROJECT_SERVER_LOG_ROOT}", server_loc[0]).replace("${SERVER_LOG_ROOT}", server_loc[0]).replace("${WAS_SERVER_NAME}", "").replace("${LOG_ROOT}", "")
                        system_out = system_out[0].replace("${PROJECT_SERVER_LOG_ROOT}", server_loc[0]).replace("${SERVER_LOG_ROOT}", server_loc[0]).replace("${WAS_SERVER_NAME}", "").replace("${LOG_ROOT}", "")
                        system_err = system_err[0].replace("${PROJECT_SERVER_LOG_ROOT}", server_loc[0]).replace("${SERVER_LOG_ROOT}", server_loc[0]).replace("${WAS_SERVER_NAME}", "").replace("${LOG_ROOT}", "")

                        html_info = [server["ENV"], server["CELL"], server["SERVER"], server["V"], system_out, system_err, stdout, stderr]
                        html.tableBody(html_info)

                except IOError as e:
                        log.writeLog(str(e))

html.tableEnd()
html.foot()
log.endLog()
log.endLog()
