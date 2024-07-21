---@meta
---@alias sendable nil|boolean|number|string|Url|table

--- You can invoke external programs through.
--- ```lua
--- local child, err = Command("ls")
---   :args({ "-a", "-l" })
---   :stdout(Command.PIPED)
---   :spawn()
--- ```
--- Compared to Lua's `os.execute`,
--- it provides many comprehensive and convenient methods,
--- and the entire process is async.
--- It takes better advantage of the benefits of concurrent scheduling.
--- However, it can only be used in async contexts, such as preloaders,
--- previewers, and async functional plugins.
---@class Command
---@operator call(string): Command
Command = {}

---@alias cfg `Command.PIPED`|`Command.NULL`|`Command.INHERIT`

--- Append an argument to the command.
--- ```lua
--- local cmd = Command("ls"):arg("-a"):arg("-l")
--- ```
---@param arg string The argument to be appended.
---@return Command
function Command:arg(arg) end

--- Append multiple arguments to the command.
--- ```lua
--- local cmd = Command("ls"):args({ "-a", "-l" }):args({ "-h" })
--- ```
---@param args string[] The arguments to be appended.
---@return Command
function Command:args(args) end

--- Set the current working directory of the command.
--- ```lua
--- local cmd = Command("ls"):cwd("/root")
--- ```
---@param dir string The directory of the command.
---@return Command
function Command:cwd(dir) end

--- Append an environment variable to the command.
--- ```lua
--- local cmd = Command("ls"):env("PATH", "/bin"):env("HOME", "/home")
--- ```
---@param key string The key of the environment variable.
---@param value string The value of the environment variable.
---@return Command
function Command:env(key, value) end

--- Set the stdin of the command.
--- If not set, the stdin will be null.
--- ```lua
--- local cmd = Command("ls"):stdin(Command.PIPED)
--- ```
---@param cfg cfg The configuration of the stdin.
---@return Command
function Command:stdin(cfg) end

--- Set the stdout of the command.
--- If not set, the stdout will be null.
--- ```lua
--- local cmd = Command("ls"):stdout(Command.PIPED)
--- ```
---@param cfg cfg The configuration of the stdout.
---@return Command
function Command:stdout(cfg) end

--- Set the stderr of the command.
--- If not set, the stderr will be null.
--- ```lua
--- local cmd = Command("ls"):stderr(Command.PIPED)
--- ```
---@param cfg cfg The configuration of the stderr.
---@return Command
function Command:stderr(cfg) end

--- Spawn the command.
--- ```lua
--- local child, err = Command("ls"):spawn()
--- ```
---@return Child? child The Child of the command if successful.
---@return integer? err The error code if the operation is failed.
function Command:spawn() end

--- Spawn the command and wait for it to finish.
--- ```lua
--- local output, err = Command("ls"):output()
--- ```
---@return Output? output The Output of the command if successful.
---@return integer? err The error code if the operation is failed.
function Command:output() end

--- This object is created by `Command:spawn()` and represents a running child process.
--- You can access the runtime data of this process through its proprietary methods.
---@class Child
child = {}

--- Let's say "available data source" refers to stdout or stderr that has been set with `Command.PIPED`, or them both.
--- `read()` reads data from the available data source alternately, and the `event` indicates the source of the data:
--- The data comes from stdout if event is 0
--- The data comes from stderr if event is 1
--- There's no data to read from both stdout and stderr, if event is 2
--- ```lua
--- local data, event = child:read(1024)
--- ```
---@param len integer
---@return string? data
---@return 0|1|2 event
function child:read(len) end

--- Similar to read(), but it reads data line by line.
--- ```lua
--- local line, event = child:read_line()
--- ```
---@return string? line
---@return 0|1|2 event
function child:read_line() end

--- ```lua
--- local line, event = child:wait_line_with { timeout = 500 }
--- ```
--- Similar to read_line(), but it accepts a table of options.
--- And includes the following additional events.
--- Timeout if event is 3
---@param opts { timeout:integer } timeout in milliseconds.
---@return string? line
---@return 0|1|2 event
function child:read_line_with(opts) end

--- ```lua
--- local status, err = child:wait()
--- ```
--- Wait for the child process to finish, returns (status, err):
--- status - The Status of the child process if successful; otherwise, nil
--- err - The error code if the operation is failed, which is an integer if any
function child:wait() end

--- ```lua
--- local output, err = child:wait_with_output()
--- ```
--- Wait for the child process to finish and get the output, returns (output, err):
--- output - The Output of the child process if successful; otherwise, nil
--- err - The error code if the operation is failed, which is an integer if any
function child:wait_with_output() end

--- ```lua
--- local ok, err = child:start_kill()
--- ```
--- Send a SIGTERM signal to the child process, returns (ok, err):
--- ok - Whether the operation is successful, which is a boolean
--- err - The error code if the operation is failed, which is an integer if any
function child:start_kill() end

--- Properties:
--- status: The Status of the child process
--- stdout: The stdout of the child process, which is a string
--- stderr: The stderr of the child process, which is a string
---@class Output
local Output = {}

--- This object represents the exit status of a child process, and it is created by wait(), or output().
--- Properties:
--- success: whether the child process exited successfully, which is a boolean.
--- code: the exit code of the child process, which is an integer if any
---@class Status
local Status = {}
