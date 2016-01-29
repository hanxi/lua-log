local log = {}
log.DEBUG = 4
log.INFO  = 3
log.WARN  = 2
log.ERROR = 1
log.level = log.DEBUG

local print = print
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local tostring = tostring
local next = next
local select = select
local date = os.date

local function table_to_string(root)
    local cache = {  [root] = "." }
    local function _dump(t,space,name)
        local temp = {}
        for k,v in pairs(t) do
            local key = tostring(k)
            if cache[v] then
                tinsert(temp,"+" .. key .. " {" .. cache[v].."}")
            elseif type(v) == "table" then
                local new_key = name .. "." .. key
                cache[v] = new_key
                tinsert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. srep(" ",#key),new_key))
            else
                tinsert(temp,"+" .. key .. " [" .. tostring(v).."]")
            end
        end
        return tconcat(temp,"\n"..space)
    end
    return _dump(root, "","")
end

local function log_write_stdout(...)
    io.write(...)
end

local function log_write_stderr(...)
    io.stderr:write(...)
end

local log_write = log_write_stdout
local function log_print(...)
    log_write(os.date("[%Y-%m-%d %H:%M:%S] "))
    local n = select('#',...)
    for i=1,n  do
        local arg = select(i,...)
        if type(arg) == "table" then
            log_write("\n[TABLE] :\n")
            log_write(table_to_string(arg))
        else
            log_write(arg)
        end
        log_write("\t")
    end
    log_write("\n")
end

log.debug = function(...)
    if log.level<log.DEBUG then
        return
    end
    log_write = log_write_stdout
    log_write('[DEBUG] ')
    log_print(...)
end

log.info = function(...)
    if log.level<log.INFO then
        return
    end
    log_write = log_write_stdout
    log_write('[INFO ] ')
    log_print(...)
end

log.warn = function(...)
    if log.level<log.WARN then
        return
    end
    log_write = log_write_stderr
    log_write('\x1B[33m[WARN ] ')
    log_print(...)
    log_write('\x1B[0m')
end

log.error = function(...)
    if log.level<log.ERROR then
        return
    end
    log_write = log_write_stderr
    log_write('\x1B[31m[ERROR] ')
    log_print(...)
    log_write('\x1B[0m')
end

log.set = function(level)
    log.level = level
end

return log

