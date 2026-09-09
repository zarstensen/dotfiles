local constants = require("overseer.constants")
local task_list = require("overseer.task_list")
local util = require("overseer.util")
local STATUS = constants.STATUS

local symbols = {
	[STATUS.FAILURE] = "󰅚 ",
	[STATUS.CANCELED] = " ",
	[STATUS.SUCCESS] = "󰄴 ",
	[STATUS.RUNNING] = "󰑮 ",
}

return function()
	local tasks = task_list.list_tasks()
	local tasks_by_status = util.tbl_group_by(tasks, "status")
	local pieces = { "󰍹" }

	for _, status in ipairs(STATUS.values) do
		local status_tasks = tasks_by_status[status]
		if symbols[status] and status_tasks then
			table.insert(pieces, symbols[status] .. #status_tasks)
		end
	end
	--
	-- Get most recently finished task
	local sorted = task_list.list_tasks({ sort = task_list.sort_finished_recently })
	if sorted[1] and sorted[1].status ~= STATUS.PENDING then
		local name = require("utils.str_utils").truncate(sorted[1].name, 30)
		table.insert(pieces, " - " .. name)
	end

	return table.concat(pieces, " ") .. " |"
end
