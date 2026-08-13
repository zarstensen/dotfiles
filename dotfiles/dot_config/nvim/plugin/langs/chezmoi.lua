vim.filetype.add({
	pattern = {
		[".*%.tmpl$"] = function(path, _)
			print("YOOOOOOOO")
			local ext = path:match("%.(%w+)%.tmpl$")
			if ext then
				return vim.filetype.match({ ext = ext })
			end
		end,
	},
})
