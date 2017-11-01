print("\n");
print("JN HoneyBot Started");

print("start loader....");

local luaFiles = {
    "apConfig.lua",
    "apInit.lua",
    "httpServer.lua",
    "gpioInit.lua"
};

--local luaFile = {"apsta.lua"}
for i, f in ipairs(luaFiles) do
    if(file.exists(f)) then
        print("procss compiling lua file:" ..f);
        --if file is lua file then complie it, and delete it
        if(string.find(f,".lua")) then
            print("complie file:"..f);
            node.compile(f);
            file.remove(f);
        end
    end
end
--    
luaFiles = nil;
collectgarbage();

-- the lc file have loading dependency, there for it require index order. 
local lcFiles = {
    "apConfig.lc",
    "apInit.lc",
    "gpioInit.lc",
    "httpServer.lc"
}   

for i, f in ipairs(lcFiles) do
    if(file.exists(f)) then
        if(string.find(f,".lc")) then
            print("procss lua run time file:" ..f);
            dofile(f);
        end
    end
end
lcFiles = nil;
collectgarbage();

