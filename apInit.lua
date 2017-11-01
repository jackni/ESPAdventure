-- apConfig is the global table.
print("soft AP init start...");
local tempApCfg = {};
tempApCfg.ssid = apConfig.apssid;
-- tempApCfg.pwd default no password. 
tempApCfg.ip = apConfig.ip;
tempApCfg.netmask = apConfig.netmask;    
tempApCfg.gateway =apConfig.gateway;
tempApCfg.start = apConfig.dhcp_startip;
tempApCfg.endip = apConfig.dhcp_endip;

wifi.setmode(wifi.SOFTAP);
wifi.ap.config(tempApCfg,false);
wifi.ap.setip(tempApCfg);
print("configure dhcp....")
wifi.ap.dhcp.config(tempApCfg);
print("dhcp range start IP:" .. tempApCfg.start .. " end IP: " .. tempApCfg.endip);
wifi.ap.dhcp.start();

print("soft AP init ending...");
