---@meta
--- Yazi's DDS (Data Distribution Service) uses a Lua-based publish-subscribe model as its carrier.
--- That is, you can achieve cross-instance communication and state persistence through the ps API.
--- See `DDS` for details.
--- The following functions can only be used within a sync context.
---@class ps
ps = {}

--- Publish a message to the current instance,
--- and all plugins subscribed through `sub()` for this `kind` will receive it,
--- achieving internal communication within the instance.
--- Since the `kind` is used globally, to add the plugin name as the prefix is a best practice.
--- For example, the combination of the plugin `my-plugin` and the kind event1 would be `my-plugin-event1`.
--- ```lua
--- ps.pub("greeting", "Hello, World!")
--- ```
---@param kind string The kind of the message, which is a string of alphanumeric with dashes, and cannot be `built-in kinds`.
---@param value sendable The value of the message.
function ps.pub(kind, value) end

--- Publish a message to a specific instance with `receiver` as the ID:
---   - If the receiver is the current instance (local), and is subscribed to this `kind` through `sub()`, it will receive this message.
---   - If the receiver is not the current instance (remote), and is subscribed to this `kind` through `sub_remote()`, it will receive this message.
--- ```lua
--- ps.pub_to(1711957283332834, "greeting", "Hello, World!")
--- ```
---@param receiver integer ID of the remote instance, which is a integer; if it's 0 then broadcasting to all remote instances
---@param kind string The kind of the message, which is a string of alphanumeric with dashes, and cannot be `built-in kinds`.
---@param value sendable The value of the message.
function ps.pub_to(receiver, kind, value) end

--- Broadcast a static message to all remote instances subscribed to this `kind` through `sub_remote()`.
--- The message will be stored as static data to achieve state persistence, and when a new instance is created,
--- it will receive all static messages broadcasted by `sub_remote()` before in descending order of `severity` to restore its state from the data.
--- If you simply want to broadcast a message to all remote instances,
--- without the need for the message to be persisted, use `ps.pub_to()` with receiver `0` instead.
--- ```lua
--- -- Broadcast and store a static message
--- ps.pub_static(10, "greeting", "Hello, World!")
--- -- Broadcast and remove a static message
--- ps.pub_static(10, "greeting", nil)
--- ```
---@param severity integer The severity of the message, which is an integer with a range of 0 to 65535.
---@param kind string The kind of the message, which is a string of alphanumeric with dashes, and cannot be `built-in kinds`.
---@param value sendable? The value of the message. If the value is nil, the static message will be unpersisted.
function ps.pub_static(severity, kind, value) end

--- Subscribe to local messages of kind and call the callback handler for it.
--- which runs in a sync context, so you can access app data via `cx` for the content of interest.
--- Note: No time-consuming operations should be done in the callback,
--- and the same kind from the same plugin can only be subscribed once,
--- re-subscribing `sub()` before unsubscribing `unsub()` will throw an error.
--- ```lua
--- ps.sub("cd", function(body)
---   ya.err("New cwd", cx.active.current.cwd)
--- end)
--- ```
---@param kind string The kind of the message.
---@param callback fun(body:sendable) The callback function, with a single parameter `body` containing the content of the message.
function ps.sub(kind, callback) end

--- Similar to sub(), but it subscribes to remote messages of this kind instead of local.
---@param kind string The kind of the message.
---@param callback fun(body:sendable) The callback function, with a single parameter `body` containing the content of the message.
function ps.sub_remote(kind, callback) end

--- Unsubscribe from local messages of this kind.
--- ```lua
--- ps.unsub("my-message")
--- ```
---@param kind string The kind of the message.
function ps.unsub(kind) end

--- Unsubscribe from remote messages of this kind.
--- ```lua
--- ps.unsub_remote("my-message")
--- ```
---@param kind string The kind of the message.
function ps.unsub_remote(kind) end
