---@class Debounce
---@field debounce_timer uv.uv_timer_t
---@field debounce_dur number
local P = {}

---@param debounce_dur number
---@return Debounce
function P:new(debounce_dur)
	---@type Debounce
	local o = {
		debounce_timer = vim.uv.new_timer() or error("Could not create timer"),
		debounce_dur = debounce_dur,
	}

	setmetatable(o, { __index = self })

	return o
end

function P:close()
    self.debounce_timer:close()
end

---@param self Debounce
---@param callback fun()
function P:debounce(callback)
	self.debounce_timer:stop()
	self.debounce_timer:start(self.debounce_dur, 0, vim.schedule_wrap(callback))
end

---@param self Debounce
---@param callback fun(...)
---@return fun(...)
function P:debounced(callback)
	return function(...)
		local args = { ... }
		self:debounce(function()
			callback(args)
		end)
	end
end

return P
