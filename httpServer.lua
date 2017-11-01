--TODO: this should be in sperate module
function processRequestPayload(payload)
    _, j = string.find(payload, 'led_light_switch=')
    if j ~= nil then
        command = string.sub(payload, j + 1); --compile error
        if command == 'on' then
            gpio.write(onboardLEDPin, 1);
            gpio.write(extLEDPin,1);
        else
            gpio.write(onboardLEDPin, 0);
            gpio.write(extLEDPin,0);
        end
    end
end

function processHtmlRequest(socket)
    local fileSize = 0;
    local fileName = "index.html";
    if(file.exists(fileName)) then
        fileInfo = file.stat(fileName);
        fileSize = fileInfo.size;
        local html = "";
        if file.open(fileName, "r") then
            html = file.read(); 
            file.close();
        end
        
        socket:send("HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n");
        --socket:send("Content-Length:" .. fileSize .. "\r\n");
        --socket:send("Connection:close\r\n\r\n");
        socket:send(html);

    else
        socket:send("HTTP/1.1 400 Not Found\r\nContent-Type: text/html\r\n\r\n");
        socket:send("Content-Length: 15 \r\n");
        socket:send("Page Not found!");
    end
end

--The receive event is fired for every network frame
--exceeds 1460 bytes (derived from Ethernet frame size) it will fire more than once. 
local buffer = nil;
function onReceive(socket, payload) 
    if buffer == nil then
        buffer = payload;
    else
        buffer = buffer .. payload;
    end
    print("onReceive Event triggerd");
    print(buffer);
    -- processing post payload
    processRequestPayload(buffer);
    if(string.find(buffer,"HTTP") ~= nil) then
        processHtmlRequest(socket);
    end
    buffer = nil;
    payload = nil;
    collectgarbage();
end

function onSent(socket)
    print("OnSent Triggered");
    socket:close();
    socket = nil;
    collectgarbage();    
end

function onConnect(socket)
    print("OnConnect Event Triggerd")
end

function onReconnect(socket,errorCode)
    print(errorCode);
end

function onDisconnect(socket,errorCode)
    print(errorCode);
end

-- maxFileSize = 65535; -- 64kb
print("Http server heap size:"..node.heap().."  port:80");
print("http server init, loading index.html file");
print("creating tcp server... 60sec timeout");
--sckTcpSrv = net.createServer(net.TCP, 60);
print("configure listen port 80");
srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", onReceive);
    conn:on("sent", onSent);
    conn:on("connection", onConnect);
    conn:on("reconnection", onReconnect);
    conn:on("disconnection",onDisconnect);
    collectgarbage();
end);
