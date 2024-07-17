---@diagnostic disable: unused-local
---@class Ya
-- Hide Yazi to the secondary screen by returning to the terminal,
-- completely controlled by the requested plugin.
-- ```lua
-- local permit = ya.hide()
-- ```
-- This method returns a permit for this resource.
-- When it's necessary to restore the TUI display, call its drop() method:
-- ```lua
-- permit:drop()
-- ```
-- Note that since there's always only one available terminal control resource,
-- ya.hide() cannot be called again before the previous permit is dropped,
-- otherwise an error will be thrown, effectively avoiding deadlocks.
-- This function is only available in the async context.
---@field hide fun(): unknown
---@field manager_emit fun(cmd:string, args:any[])
---@field image_show fun(url:Url, rect:Rect)
---@field image_precache fun(src:Url, dist:Url)
---@field which fun(opts:{ cands:{ on:string|string[], desc:string? }[], silent:boolean? }) number?
---@field input fun(opts:{ title:string, value:string?, position:})

---@class ya.file_cache.opts
---@field file File The File to be cached
-- The number of units to skip.
-- It's units largely depend on your previewer,
-- such as lines for code, and percentages for videos
---@field skip number

-- Calculate the cached Url corresponding to the given file
---@return Url? url If the file is cacheable, for example it is not ignored in the user configuration and the file itself is not a cache.
function ya.file_cache(opts) end

---@alias position "top-left"|"top-center"|"top-right"|"bottom-left"|"bottom-center"|"bottom-right"|"center"|"hovered"
---@class ya.input.opts
---@field title string The title of the input.
---@field value string? The default value of the input.
---@field position { [1]:position, x:integer?, y:integer?, w:integer, h:integer? }
---@field realtime boolean? Whether to report user input in real time.
---The number of seconds to wait for the user to stop typing,
---which is a positive float. Can only be used when realtime = true.
---(Currently needs the nightly version of Yazi)
---@field debounce number?

---@param opts ya.input.opts
function ya.input(opts) end
