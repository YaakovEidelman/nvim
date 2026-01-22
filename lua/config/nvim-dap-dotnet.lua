-- lua/config/nvim-dap-dotnet.lua
-- Helper functions for .NET debugging with nvim-dap

local M = {}

local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

-- Normalize path - use backslashes on Windows for netcoredbg compatibility
local function normalize_path(path)
    if is_windows then
        return path:gsub("/", "\\")
    end
    return path
end

-- Find the root directory of a .NET project by searching for .csproj files
function M.find_project_root_by_csproj(start_path)
    local Path = require("plenary.path")
    local path = Path:new(start_path)

    while true do
        local csproj_files = vim.fn.glob(path:absolute() .. "/*.csproj", false, true)
        if #csproj_files > 0 then
            return normalize_path(path:absolute())
        end

        local parent = path:parent()
        if parent:absolute() == path:absolute() then
            return nil
        end

        path = parent
    end
end

-- Find the highest version of the netX.Y folder within a given path.
function M.get_highest_net_folder(bin_debug_path)
    local dirs = vim.fn.glob(bin_debug_path .. "/net*", false, true)

    if #dirs == 0 then
        error("No netX.Y folders found in " .. bin_debug_path .. ". Have you built the project?")
    end

    -- Sort by version number (net8.0 > net7.0 > net6.0, etc.)
    table.sort(dirs, function(a, b)
        local ver_a = tonumber(a:match("net(%d+)")) or 0
        local ver_b = tonumber(b:match("net(%d+)")) or 0
        return ver_a > ver_b
    end)

    return normalize_path(dirs[1])
end

-- Build and return the full path to the .dll file for debugging.
function M.build_dll_path()
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir = vim.fn.fnamemodify(current_file, ":p:h")

    local project_root = M.find_project_root_by_csproj(current_dir)
    if not project_root then
        error("Could not find project root (no .csproj found)")
    end

    local csproj_files = vim.fn.glob(project_root .. "/*.csproj", false, true)
    if #csproj_files == 0 then
        error("No .csproj file found in project root")
    end

    local project_name = vim.fn.fnamemodify(csproj_files[1], ":t:r")
    local bin_debug_path = normalize_path(project_root .. "/bin/Debug")

    -- Check if bin/Debug exists
    if vim.fn.isdirectory(bin_debug_path) == 0 then
        error("bin/Debug folder not found. Please build the project first with 'dotnet build --configuration Debug'")
    end

    local highest_net_folder = M.get_highest_net_folder(bin_debug_path)
    local dll_path = normalize_path(highest_net_folder .. "/" .. project_name .. ".dll")
    local pdb_path = normalize_path(highest_net_folder .. "/" .. project_name .. ".pdb")

    -- Verify the DLL exists
    if vim.fn.filereadable(dll_path) == 0 then
        error("DLL not found: " .. dll_path .. ". Please build the project first.")
    end

    -- Check for PDB file (required for breakpoints)
    if vim.fn.filereadable(pdb_path) == 0 then
        vim.notify("WARNING: PDB file not found: " .. pdb_path .. "\nBreakpoints may not work!", vim.log.levels.WARN)
    else
        vim.notify("PDB found: " .. pdb_path, vim.log.levels.DEBUG)
    end

    vim.notify("Launching: " .. dll_path, vim.log.levels.INFO)
    return dll_path
end

return M
