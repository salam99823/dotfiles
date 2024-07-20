---@meta
--- The following functions can only be used within an async context.
---@class fs
fs = {}

--- Write data to the specified file.
--- ```lua
--- local ok, err = fs.write(url, "hello world")
--- ```
--- ### Returns
--- #### ok: Whether the operation is successful.
--- #### err: The error code if the operation is failed.
---@param url Url The `Url` of the file
---@param data string The data to be written.
---@return boolean ok
---@return integer? err
function fs.write(url, data) end

--- Get the `Cha` of the specified file,
--- which is faster than `cha_follow()` since it never follows the symbolic link.
--- ```lua
--- local cha, err = fs.cha(url)
--- ```
--- ### Returns
--- #### cha: `Cha` of the file if successful; otherwise, nil.
--- #### err: The error code if the operation is failed.
---@param url Url The `Url` of the file
---@return Cha? cha
---@return integer? err
function fs.cha(url) end

--- Get the `Cha` of the specified file,
--- and follow the symbolic link.
--- ```lua
--- local cha, err = fs.cha_follow(url)
--- ```
--- ### Returns
--- #### cha: `Cha` of the file if successful; otherwise, nil.
--- #### err: The error code if the operation is failed.
---@param url Url The `Url` of the file
function fs.cha_follow(url) end
