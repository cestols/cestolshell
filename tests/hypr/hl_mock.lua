-- SPDX-License-Identifier: GPL-3.0-only
-- Copyright (C) 2026 Cestols

-- tests/hypr/hl_mock.lua: strict, recording mock of the `hl` API.
-- The API surface is parsed from the stubs shipped with Hyprland (hl.meta.lua),
-- so calling a function the installed Hyprland does not have raises an error.

local M = {}

local DEFAULT_STUBS = "/usr/share/hypr/stubs/hl.meta.lua"

-- Parse `---@class HL.X` blocks into { [class] = { [field] = type } }.
local function parse_stubs(path)
    local file, err = io.open(path, "r")
    if not file then
        error("cannot open Hyprland stubs: " .. err)
    end

    local classes, current = {}, nil
    for line in file:lines() do
        local class = line:match("^%-%-%-@class ([%w%.]+)%s*$")
        if class then
            current = {}
            classes[class] = current
        elseif current then
            local name, ty = line:match("^%-%-%-@field ([%w_]+) (%S+)")
            if name then
                current[name] = ty
            elseif not line:match("^%-%-%-") then
                current = nil
            end
        end
    end
    file:close()

    assert(classes["HL.API"], "no HL.API class found in " .. path)
    return classes
end

-- Path of the Lua file that called into the mock (skips the mock's own frames).
local function caller_source()
    local own = debug.getinfo(1, "S").source
    for level = 2, 20 do
        local info = debug.getinfo(level, "S")
        if not info then
            break
        end
        if info.source ~= own and info.source:sub(1, 1) == "@" then
            return info.source:sub(2)
        end
    end
    return "?"
end

local function strict(tbl, path)
    return setmetatable(tbl, {
        __index = function(_, key)
            error(("unknown hl function: %s%s (not in Hyprland stubs)"):format(path, tostring(key)), 2)
        end,
    })
end

-- Returns `hl, log`. `log.calls` lists every call as { fn, args, source, submap }.
function M.new(stubs_path)
    local classes = parse_stubs(stubs_path or DEFAULT_STUBS)
    local log = { calls = {}, submap = nil }

    local function record(fn, args)
        local call = { fn = fn, args = args, source = caller_source(), submap = log.submap }
        table.insert(log.calls, call)
        return call
    end

    local function build(class, path)
        local tbl = {}
        for name, ty in pairs(classes[class]) do
            local full = path .. name
            if classes[ty] then
                tbl[name] = build(ty, full .. ".")
            elseif ty:match("^fun") then
                tbl[name] = function(...)
                    local call = record(full, table.pack(...))
                    -- Dispatcher constructors return a value that hl.bind receives.
                    if path:match("^hl%.dsp%.") then
                        return { dispatcher = full, args = call.args }
                    end
                    return nil
                end
            end
        end
        return strict(tbl, path)
    end

    local hl = build("HL.API", "hl.")

    -- Binds declared inside a submap callback belong to that submap.
    local define_submap = hl.define_submap
    rawset(hl, "define_submap", function(name, reset_or_fn, fn)
        define_submap(name, reset_or_fn, fn)
        local body = type(reset_or_fn) == "function" and reset_or_fn or fn
        if type(body) == "function" then
            local previous = log.submap
            log.submap = name
            body()
            log.submap = previous
        end
    end)

    return hl, log
end

-- Calls with the given function name, e.g. M.find(log, "hl.window_rule").
function M.find(log, fn)
    local found = {}
    for _, call in ipairs(log.calls) do
        if call.fn == fn then
            table.insert(found, call)
        end
    end
    return found
end

return M
