-- SPDX-License-Identifier: GPL-3.0-only
-- Copyright (C) 2026 Cestols

-- tests/hypr/test_config.lua: checks on the Hyprland Lua config that `Hyprland --verify-config` misses
-- Covers callback bodies, duplicates and project rules.
-- Usage: lua tests/hypr/test_config.lua [hypr config dir] [hl.meta.lua path]

local here = debug.getinfo(1, "S").source:sub(2):match("^(.*)/") or "."
package.path = here .. "/?.lua;" .. package.path
local mock = require("hl_mock")

local root = arg[1] or (here .. "/../../dots/.config/hypr")
local hl, log = mock.new(arg[2])

local failures, passed = {}, 0

local function test(name, fn)
    local ok, err = pcall(fn)
    if ok then
        passed = passed + 1
        print("ok    " .. name)
    else
        table.insert(failures, name)
        print("FAIL  " .. name .. "\n      " .. tostring(err):gsub("\n", "\n      "))
    end
end

local function short(path)
    return (path:gsub("^.*/hypr/", ""))
end

-- Collect every problem before failing, so one run shows all of them.
local function expect_none(problems)
    if #problems > 0 then
        error(table.concat(problems, "\n"), 0)
    end
end

-- ######## Load ########

package.path = root .. "/?.lua;" .. root .. "/?/init.lua;" .. package.path
rawset(_G, "hl", hl)

-- `hl` is the only global allowed: any other assignment fails the load.
local leaked = {}
setmetatable(_G, {
    __newindex = function(_, key, value)
        local info = debug.getinfo(2, "Sl")
        table.insert(leaked, ("%s:%d: global '%s'"):format(short(info.short_src), info.currentline, key))
        rawset(_G, key, value)
    end,
})

test("config loads with the strict hl mock", function()
    dofile(root .. "/hyprland.lua")
end)

test("no global variables besides hl", function()
    expect_none(leaked)
end)

-- ######## Callbacks ########

-- Functions passed to hl.on / hl.bind / hl.gesture / hl.timer only run at runtime,
-- so verify-config never sees them. Run each one against the mock.
test("callbacks only use existing hl functions", function()
    local callbacks = {}
    local function add(where, fn)
        if type(fn) == "function" then
            table.insert(callbacks, { where = where, fn = fn })
        end
    end
    for _, call in ipairs(mock.find(log, "hl.on")) do
        add(("hl.on(%q) in %s"):format(tostring(call.args[1]), short(call.source)), call.args[2])
    end
    for _, call in ipairs(mock.find(log, "hl.bind")) do
        add(("hl.bind(%q) in %s"):format(tostring(call.args[1]), short(call.source)), call.args[2])
    end
    for _, call in ipairs(mock.find(log, "hl.gesture")) do
        add("hl.gesture in " .. short(call.source), type(call.args[1]) == "table" and call.args[1].action)
    end
    for _, call in ipairs(mock.find(log, "hl.timer")) do
        add("hl.timer in " .. short(call.source), call.args[1])
    end

    local problems = {}
    for _, cb in ipairs(callbacks) do
        local ok, err = pcall(cb.fn)
        if not ok then
            table.insert(problems, cb.where .. ": " .. tostring(err))
        end
    end
    expect_none(problems)
end)

-- ######## Duplicates ########

-- Rules with the same name silently replace each other.
local function unique_names(fn, field)
    local seen, problems = {}, {}
    for _, call in ipairs(mock.find(log, fn)) do
        local spec = call.args[1]
        local name = type(spec) == "table" and spec[field] or spec
        if name == nil then
            table.insert(problems, ("%s without '%s' in %s"):format(fn, field, short(call.source)))
        elseif seen[name] then
            table.insert(
                problems,
                ("duplicate %s %q in %s (first in %s)"):format(fn, name, short(call.source), seen[name])
            )
        else
            seen[name] = short(call.source)
        end
    end
    expect_none(problems)
end

test("window rule names are unique", function()
    unique_names("hl.window_rule", "name")
end)

test("layer rule names are unique", function()
    unique_names("hl.layer_rule", "name")
end)

test("workspace rules are not repeated", function()
    unique_names("hl.workspace_rule", "workspace")
end)

test("curve names are unique", function()
    unique_names("hl.curve", 1)
end)

-- "SUPER + SHIFT + q" and "shift+super+Q" are the same bind.
local function normalize_keys(keys)
    local parts = {}
    for part in tostring(keys):gmatch("[^+]+") do
        table.insert(parts, part:match("^%s*(.-)%s*$"):upper())
    end
    table.sort(parts)
    return table.concat(parts, "+")
end

test("keybinds are not bound twice", function()
    local seen, problems = {}, {}
    for _, call in ipairs(mock.find(log, "hl.bind")) do
        local opts = call.args[3] or {}
        local id = ("%s|%s|%s"):format(
            call.submap or "",
            normalize_keys(call.args[1]),
            opts.release and "release" or ""
        )
        local where = short(call.source)
        if seen[id] then
            table.insert(problems, ("duplicate bind %q in %s (first in %s)"):format(call.args[1], where, seen[id]))
        else
            seen[id] = where
        end
    end
    expect_none(problems)
end)

-- ######## Project rules ########

local SHELL_PATTERNS = { "%f[%w]qs%f[%W]", "quickshell" }

local function calls_shell(text)
    for _, pattern in ipairs(SHELL_PATTERNS) do
        if tostring(text):find(pattern) then
            return true
        end
    end
    return false
end

test("level-1 keybinds never call the shell", function()
    local problems = {}
    for _, call in ipairs(log.calls) do
        if call.source:match("keybinds/essential%.lua$") then
            for i = 1, call.args.n do
                if type(call.args[i]) == "string" and calls_shell(call.args[i]) then
                    table.insert(problems, ("%s(%q) in keybinds/essential.lua"):format(call.fn, call.args[i]))
                end
            end
        end
    end
    expect_none(problems)
end)

test("shell binds use IPC, never global shortcuts", function()
    local problems = {}
    for _, call in ipairs(mock.find(log, "hl.dsp.global")) do
        table.insert(problems, "hl.dsp.global in " .. short(call.source))
    end
    expect_none(problems)
end)

-- IPC functions the shell exposes, as a set of "target.fn": every `function name(`
-- after a `target: "..."` line in the QML files under quickshell/<qs_config>.
local function shell_ipc_functions(shell_dir)
    local found = {}
    local list = io.popen(("find %q -name '*.qml' 2>/dev/null"):format(shell_dir))
    for path in list:lines() do
        local target
        for line in io.lines(path) do
            target = line:match('^%s*target:%s*"([^"]+)"') or target
            local fn = target and line:match("^%s*function%s+([%w_]+)%s*%(")
            if fn then
                found[target .. "." .. fn] = true
            end
        end
    end
    list:close()
    return found
end

-- Level 2 binds grow with the shell (from 0.1): every bind in keybinds/shell.lua
-- must dispatch a `qs -c <config> ipc call <target> <fn>` built by hyprland.qs.ipc,
-- and <target>.<fn> must be declared by an IpcHandler of the shell.
test("level-2 keybinds go through the qs IPC helper", function()
    local qs_config = require("hyprland.variables").qs_config
    local available = shell_ipc_functions(root .. "/../quickshell/" .. qs_config)
    local problems = {}
    for _, call in ipairs(mock.find(log, "hl.bind")) do
        if call.source:match("keybinds/shell%.lua$") then
            local dsp = call.args[2]
            local cmd = type(dsp) == "table" and dsp.dispatcher == "hl.dsp.exec_cmd" and dsp.args[1]
            local config, target, fn
            if type(cmd) == "string" then
                config, target, fn = cmd:match("^qs %-c '([^']*)' ipc call '([^']*)' '([^']*)'")
            end
            if not config then
                table.insert(
                    problems,
                    ("bind %q in keybinds/shell.lua does not use the IPC helper"):format(call.args[1])
                )
            elseif config ~= qs_config then
                table.insert(problems, ("bind %q calls config %q, not %q"):format(call.args[1], config, qs_config))
            elseif not available[target .. "." .. fn] then
                table.insert(
                    problems,
                    ("bind %q calls %s.%s, not declared by any IpcHandler"):format(call.args[1], target, fn)
                )
            end
        end
    end
    expect_none(problems)
end)

local shell_binds = io.open(root .. "/hyprland/keybinds/shell.lua")
if shell_binds then
    shell_binds:close()
    test("keybinds/shell.lua is loaded by hyprland.lua", function()
        assert(package.loaded["hyprland.keybinds.shell"], 'missing require("hyprland.keybinds.shell") in hyprland.lua')
    end)
end

-- hyprland.qs (qs/init.lua) exposes the helper submodules (ipc, ...).
-- Expected ipc API: command(target, fn, ...) returns the quoted command line,
-- call(target, fn, ...) returns hl.dsp.exec_cmd(command(...)). Skipped until qs/init.lua exists.
local qs_file = io.open(root .. "/hyprland/qs/init.lua")
if not qs_file then
    print("skip  qs IPC helper (hyprland/qs/init.lua not written yet)")
else
    qs_file:close()
    test("hyprland.qs exposes the IPC helper", function()
        local qs = require("hyprland.qs")
        assert(type(qs) == "table", "qs/init.lua must return a table")
        assert(type(qs.ipc) == "table", "qs/init.lua must expose ipc (require of hyprland.qs.ipc)")
    end)

    test("qs IPC helper builds quoted qs ipc call commands", function()
        local ipc = require("hyprland.qs").ipc
        local expected = [[qs -c 'cestolshell' ipc call 'shell' 'ping' 'it'\''s' '2']]
        local got = ipc.command("shell", "ping", "it's", 2)
        assert(got == expected, ("command: expected %q, got %q"):format(expected, got))

        local before = #mock.find(log, "hl.dsp.exec_cmd")
        ipc.call("shell", "ping")
        local calls = mock.find(log, "hl.dsp.exec_cmd")
        assert(#calls == before + 1, "call() must build exactly one hl.dsp.exec_cmd")
        assert(calls[#calls].args[1] == ipc.command("shell", "ping"), "call() must run command()")
    end)
end

-- ######## Summary ########

print(("\n%d passed, %d failed"):format(passed, #failures))
os.exit(#failures == 0 and 0 or 1)
