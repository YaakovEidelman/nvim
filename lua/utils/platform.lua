-- lua/utils/platform.lua
-- Platform detection and path utilities

local M = {}

M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

-- Normalize path - use backslashes on Windows for netcoredbg compatibility
function M.normalize_path(path)
    if M.is_windows then
        return path:gsub("/", "\\")
    end
    return path
end

return M
