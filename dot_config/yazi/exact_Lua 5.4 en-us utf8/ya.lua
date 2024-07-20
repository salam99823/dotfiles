---@meta
---@class ya
ya = {}

--- Hide Yazi to the secondary screen by returning to the terminal,
--- completely controlled by the requested plugin.
--- ```lua
--- local permit = ya.hide()
--- ```
--- This method returns a permit for this resource.
--- When it's necessary to restore the TUI display,
--- call its drop() method:
--- ```lua
--- permit:drop()
--- ```
--- Note that since there's always only one available terminal control resource,
--- ya.hide() cannot be called again before the previous permit is dropped,
--- otherwise an error will be thrown, effectively avoiding deadlocks.
--- This function is only available in the async context.
---@return unknown?
function ya.hide() end

--- Calculate the cached Url corresponding to the given file:
--- ### Options:
--- #### file: The `File` to be cached.
--- #### skip: The number of units to skip.
--- It's units largely depend on your previewer,
--- such as lines for code, and percentages for videos.
--- If the file is not allowed to be cached, such as it's ignored in the user config, or the file itself is a cache, returns nil.
---@param opts { file: File, skip: number? }
---@return Url? cache
function ya.file_cache(opts) end

--- Send a command to the `[manager]` without waiting for the executor to execute.
--- ## Example
--- ```lua
--- ya.manager_emit("my-cmd", { "hello", 123, foo = true, bar_baz = "world" })
---
--- -- Equivalent to:
--- -- my-cmd "hello" "123" --foo --bar-baz="world"
--- ```
---@param cmd string The command name.
---@param args table<number | string, sendable> The arguments of the command, which is a table with a number or string key and `sendable values`.
function ya.manager_emit(cmd, args) end

--- Display the given image within the specified area, and the image will downscale to fit that area automatically.
--- This function is only available in the async context.
---@param url Url The `Url` of the image.
---@param rect Rect The `Rect` of the area.
function ya.image_show(url, rect) end

--- Pre-cache the image to a specified url based on user-configured `max_width` and `max_height`.
--- This function is only available in the async context.
---@param src Url The source `Url` of the image
---@param dist Url The destination `Url` of the image
function ya.image_precache(src, dist) end

--- Prompt users with a set of available keys.
--- ### Options:
--- #### cands: The key candidates.
--- ##### on: The key to be prompted.
--- ##### desc: The description of the key.
--- #### silent: Whether to show the UI of key indicator.
--- ## Example
--- ```lua
--- local cand = ya.which {
---   cands = {
---     { on = "a" },
---     { on = "b", desc = "optional description" },
---     { on = "<C-c>", desc = "key combination" },
---     { on = { "d", "e" }, desc = "multiple keys" },
---   },
---   -- silent = true, -- If you don't want to show the UI of key indicator
--- }
--- ```
--- When the user clicks a valid candidate, `ya.which` returns the 1-based index of that `cand`;
--- otherwise, it returns nil, indicating that the user has canceled the key operation.
--- This function is only available in the async context.
---@param opts { cands:{ on:string|string[], desc:string? }[], silent:boolean? }
---@return number? index
function ya.which(opts) end

--- Request user input.
--- ### Options:
--- #### title: The title of the input.
--- #### value: The default value of the input.
--- #### position: The position of the input.
--- ##### 1: The origin position of the input.
--- ##### x: The X offset from the origin position.
--- ##### y: The Y offset from the origin position.
--- ##### w: The width of the input, which is an positive integer.
--- ##### h: The height of the input, which is an positive integer.
--- #### realtime: Whether to report user input in real time, which is a boolean.
--- #### debounce: The number of seconds to wait for the user to stop typing, which is a positive float. Can only be used when realtime = true. (Currently needs the nightly version of Yazi)
--- ```lua
--- local value, event = ya.input {
---   title = "Archive name:",
---   position = { "top-center", y = 3, w = 40 },
--- }
--- ```
---
--- ### Returns:
--- #### value: The user input value carried by this event, which is a string if the event is non-zero; otherwise, nil.
--- #### event: The event type:
--- ##### 0 - Unknown error.
--- ##### 1 - The user has confirmed the input.
--- ##### 2 - The user has canceled the input.
--- ##### 3 - The user has changed the input (only if realtime is true).
---
--- When realtime = true specified, ya.input() returns a receiver,
--- which has a recv() method that can be called multiple times to receive events.
--- ```lua
--- local input = ya.input {
---   title = "Input in realtime:",
---   position = { "center", w = 50 },
---   realtime = true,
--- }
---
--- while true do
---   local value, event = input:recv()
---   if not value then
---     break
---   end
---   ya.err(value)
--- end
--- ```
--- This function is only available in the async context.
---@param opts { title:string, value:string?, position:{ [1]: "top-left"|"top-center"|"top-right"|"bottom-left"|"bottom-center"|"bottom-right"|"center"|"hovered", x:integer?, y:integer?, w:integer, h:integer? }, realtime:boolean?, debounce:number? }
---@return string? value
---@return 0|1|2|3 event
function ya.input(opts) end

--- Send a foreground notification to the user.
--- ### Options:
--- #### title: The title of the notification.
--- #### content: The content of the notification.
--- #### timeout: The timeout of the notification, which is an non-negative float in seconds.
--- #### level: The level of the notification. Default is "info".
--- ## Example
--- ```lua
--- ya.notify {
---   title = "Hello, World!",
---   content = "This is a notification from Lua!",
---   timeout = 6.5,
---   -- level = "info",
--- }
--- ```
---@param opts { title:string, content:string, timeout:number, level:"info"|"warn"|"error" }
function ya.notify(opts) end

--- Append messages to the log file at the debug level.
--- ## Example
--- ```lua
--- ya.dbg("Hello", "World!")                       -- Multiple arguments are supported
--- ya.dbg({ foo = "bar", baz = 123, qux = true })  -- Any type of data is supported
--- ```
--- Note that if you use a release build of Yazi,
--- the log level is "error" instead of "debug", so you'll need to use `ya.err`.
---@param msg any The message to be logged.
function ya.dbg(msg, ...) end

--- Append messages to the log file at the error level.
--- ## Example
--- ```lua
--- ya.err("Hello", "World!")                       -- Multiple arguments are supported
--- ya.err({ foo = "bar", baz = 123, qux = true })  -- Any type of data is supported
--- ```
---@param msg any The message to be logged.
function ya.err(msg, ...) end

--- See `Async context`.
function ya.sync(fn) end

--- Preview the file as code into the specified area.
--- ### Options:
--- #### file: The previewed `File`.
--- #### area: The area of the preview.
--- #### skip: The number of units to skip. It's units largely depend on your previewer, such as lines for code, and percentages for videos.
--- #### window: The `Window` of the preview.
--- ### Returns:
--- #### ok: Whether the preview is successful.
--- #### upper_bound: the preview fails (ok = false) and it's because exceeds the maximum upper bound, return this bound; otherwise, nil.
--- This function is only available in the async context.
---@param opts { file:File, area:Rect, skip:number, window:Window }
---@return boolean ok
---@return unknown? upper_bound
function ya.preview_code(opts) end

--- Preview the file as an archive into the specified area.
--- ### Options:
--- #### file: The previewed `File`.
--- #### area: The area of the preview.
--- #### skip: The number of units to skip.
--- #### window: The `Window` of the preview.
--- ### Returns:
--- #### ok: Whether the preview is successful.
--- #### upper_bound: If the preview fails (ok = false) and it's because exceeds the maximum upper bound, return this bound; otherwise, nil.
--- This function is only available in the async context.
---@param opts { file:File, area:Rect, skip:number, window:Window } The options of the preview. It's the same as `preview_code()`.
---@return boolean ok
---@return unknown? upper_bound
function ya.preview_archive(opts) end

--- ### Options:
--- #### file: The previewed `File`.
--- #### area: The area of the preview.
--- #### skip: The number of units to skip. It's units largely depend on your previewer, such as lines for code, and percentages for videos
--- #### window: The `Window` of the preview.
--- This function is only available in the async context.
---@param opts { file:File, area:Rect, skip:number, window:Window }
---@param widgets any[] List of renderable widgets, such as { ui.Paragraph {...}, ui.List {...}, ... }
function ya.preview_widgets(opts, widgets) end

--- Returns the target family of the current platform, "windows", "unix", or "wasm".
---@return "windows"|"unix"|"wasm" platform
function ya.target_family() end

--- Quote characters that may have special meaning in a shell.
--- ## Example
--- ```lua
--- local handle = io.popen("ls " .. ya.quote(filename))
--- ```
---@param str string The string to be quoted.
---@return string
function ya.quote(str) end

--- Truncate the text to the specified length and return it.
--- ### Options:
--- #### max: The maximum length of the text.
--- #### rtl: Whether the text is right-to-left.
---@param text string Required, the text to be truncated, which is a string.
---@param opts { max:integer, rtl:boolean }
---@return string
function ya.truncate(text, opts) end

--- Returns the current timestamp,
--- the integer part represents the seconds,
--- and the decimal part represents the milliseconds.
---@return number
function ya.time() end

--- Waits until `secs` has elapsed.
--- ```lua
--- ya.sleep(0.5)  -- Sleep for 500 milliseconds
--- ```
--- This function is only available in the async context.
---@param secs number The number of seconds to sleep, which is a positive float
function ya.sleep(secs) end

--- Only available on Unix-like systems.
--- Returns the user id of the current user.
---@return integer
function ya.uid() end

--- Only available on Unix-like systems.
--- Returns the group id of the current user.
---@return integer
function ya.gid() end

--- Get the name of the user.
--- This function is only available on Unix-like systems.
---@param uid integer? The user id of the user, which is an integer. If not set, it will use the current user's id.
---@return string?
function ya.user_name(uid) end

--- Get the name of the user group.
--- This function is only available on Unix-like systems.
---@param gid integer? The group id of the user. If not set, it will use the current user's group id.
---@return string?
function ya.group_name(gid) end

--- Only available on Unix-like systems.
---@return string?
function ya.host_name() end

--- Get or set the content of the system clipboard.
--- ```lua
--- -- Get contents from the clipboard
--- local content = ya.clipboard()
---
--- -- Set contents to the clipboard
--- ya.clipboard("new content")
--- ```
--- This function is only available in the async context.
---@param text string? value to be set. If not provided, the content of the clipboard will be returned.
---@return string?
function ya.clipboard(text) end

---@param min any
---@param x any
---@param max any
---@return any
function ya.clamp(min, x, max) end

---@param x number
---@return integer
function ya.round(x) end

---@param a any[]
---@param b any[]
---@return any[]
function ya.list_merge(a, b) end

---@param str string|number
---@return string
---@return integer
function ya.basename(str) end

---@param size number
---@return string
function ya.readable_size(size) end

---@param path string
---@return string
function ya.readable_path(path) end

---@param position any
---@param children any
---@return unknown
function ya.child_at(position, children) end
