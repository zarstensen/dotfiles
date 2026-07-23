--- @param event vim.api.keyset.events
--- @param callback function|string
--- @param pattern (string|string[])?
--- @return integer
return function(event, callback, pattern)
    return vim.api.nvim_create_autocmd(event, {once = true, callback = callback, pattern = pattern})
end
