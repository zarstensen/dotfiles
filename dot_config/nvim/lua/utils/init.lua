local P = {}

--- Alpha blend two hex string rgb values.
--- Result is also a hex string.
--- Input hex may be prefixed with '#'.
--- Result is always prefixed with '#'.
--- @param background string background color in hex format "#RRGGBB"
--- @param foreground string foreground color in hex format "#RRGGBB"
--- @param alpha number alpha blend value [0, 1]
function P.alpha_blend(background, foreground, alpha)
	foreground = (foreground):gsub("#", "")
	background = (background):gsub("#", "")

	assert(
		background:len() == 6 and foreground:len() == 6,
		"Hex colors must have 3 channels, (6 characters, excluding '#')"
	)

	local bg_r = tonumber(background:sub(1, 2), 16)
	local bg_g = tonumber(background:sub(3, 4), 16)
	local bg_b = tonumber(background:sub(5, 6), 16)

	local fg_r = tonumber(foreground:sub(1, 2), 16)
	local fg_g = tonumber(foreground:sub(3, 4), 16)
	local fg_b = tonumber(foreground:sub(5, 6), 16)

	local out_r = fg_r * alpha + bg_r * (1 - alpha)
	local out_g = fg_g * alpha + bg_g * (1 - alpha)
	local out_b = fg_b * alpha + bg_b * (1 - alpha)

	return ("#%02X%02X%02X"):format(out_r, out_g, out_b)
end

function P.get_diag_on_line()
	local mode = vim.fn.mode()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local range = {
		mode = "line",
		start_lnum = cursor[1] - 1,
		end_lnum = cursor[1] - 1,
	}

	if mode == "v" or mode == "V" or mode == "\22" then
		local vpos = vim.fn.getpos("v")
		local v_lnum = vpos[2] - 1
		local v_col = vpos[3] - 1
		local c_lnum = cursor[1] - 1
		local c_col = cursor[2]

		range.start_lnum = math.min(v_lnum, c_lnum)
		range.end_lnum = math.max(v_lnum, c_lnum)

		if mode == "V" then
			range.mode = "line"
		else
			range.start_col = math.min(v_col, c_col)
			range.end_col = math.max(v_col, c_col)
			range.mode = mode == "\22" and "block" or "char"
		end
	end

	local all_diags = vim.diagnostic.get(0)
	local diags = {}
	for _, d in ipairs(all_diags) do
		local lnum = d.lnum or 0
		local col = d.col or 0
		if lnum >= range.start_lnum and lnum <= range.end_lnum then
			local include = true
			if range.mode == "char" and range.start_col ~= nil and range.end_col ~= nil then
				if range.start_lnum == range.end_lnum then
					include = col >= range.start_col and col <= range.end_col
				elseif lnum == range.start_lnum then
					include = col >= range.start_col
				elseif lnum == range.end_lnum then
					include = col <= range.end_col
				end
			elseif range.mode == "block" and range.start_col ~= nil and range.end_col ~= nil then
				include = col >= range.start_col and col <= range.end_col
			end

			if include then
				table.insert(diags, d)
			end
		end
	end

	if vim.tbl_isempty(diags) then
		print("No diagnostics")
		return
	end

	table.sort(diags, function(a, b)
		local a_lnum = a.lnum or 0
		local b_lnum = b.lnum or 0
		if a_lnum == b_lnum then
			return (a.col or 0) < (b.col or 0)
		end
		return a_lnum < b_lnum
	end)

	local msgs = {}
	for _, d in ipairs(diags) do
		local lnum = (d.lnum or 0) + 1
		local col = (d.col or 0) + 1
		local msg = (d.message or ""):gsub("\n", " ")
		table.insert(msgs, string.format("%d:%d: %s", lnum, col, msg))
	end

	return table.concat(msgs, " | ")
end

return P
