local P = {}

function P.truncate(str, max_len)
	if #str > max_len then
		return str:sub(1, max_len - 1) .. "…"
	end
	return str
end

return P
