local M = {}

local html_script_type_languages = {
  ["importmap"] = "json",
  ["module"] = "javascript",
  ["application/ecmascript"] = "javascript",
  ["text/ecmascript"] = "javascript",
}

local non_filetype_match_injection_language_aliases = {
  ex = "elixir",
  pl = "perl",
  sh = "bash",
  ts = "typescript",
  uxn = "uxntal",
}

local opts = vim.fn.has "nvim-0.10" == 1 and { force = true, all = false } or true

local function first_capture_node(capture)
  if type(capture) == "table" then
    return capture[#capture] or capture[1]
  end
  return capture
end

local function get_parser_from_markdown_info_string(injection_alias)
  local match = vim.filetype.match { filename = "a." .. injection_alias }
  return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
end

function M.setup()
  local query = require "vim.treesitter.query"

  query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local node = first_capture_node(match[pred[2]])
    if not node then
      return
    end

    local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
    if type(type_attr_value) ~= "string" or type_attr_value == "" then
      return
    end

    local configured = html_script_type_languages[type_attr_value]
    if configured then
      metadata["injection.language"] = configured
    else
      local parts = vim.split(type_attr_value, "/", {})
      metadata["injection.language"] = parts[#parts]
    end
  end, opts)

  query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = first_capture_node(match[pred[2]])
    if not node then
      return
    end

    local injection_alias = vim.treesitter.get_node_text(node, bufnr)
    if type(injection_alias) ~= "string" or injection_alias == "" then
      return
    end

    metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias:lower())
  end, opts)

  query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = first_capture_node(match[id])
    if not node then
      return
    end

    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
    if not metadata[id] then
      metadata[id] = {}
    end
    metadata[id].text = string.lower(text)
  end, opts)
end

return M
