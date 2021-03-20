local function get_cursor_0ind()
	local c = vim.api.nvim_win_get_cursor(0)
	c[1] = c[1] - 1
	return c
end

local function set_cursor_0ind(c)
	c[1] = c[1] + 1
	vim.api.nvim_win_set_cursor(0, c)
end

-- returns current line with text up-to and excluding the cursor.
local function get_current_line_to_cursor()
	local cur = get_cursor_0ind()
	-- cur-rows are 1-indexed, api-rows 0.
	local line = vim.api.nvim_buf_get_lines(0, cur[1], cur[1]+1, false)
	return string.sub(line[1], 1, cur[2])
end

-- delete n chars before cursor, MOVES CURSOR
local function remove_n_before_cur(n)
	local cur = get_cursor_0ind()
	vim.api.nvim_buf_set_text(0, cur[1], cur[2]-n, cur[1], cur[2], {""})
	cur[2] = cur[2]-n
	set_cursor_0ind(cur)
end

local function mark_pos_equal(m1, m2)
	local p1 = vim.api.nvim_buf_get_extmark_by_id(0, Ns_id, m1, {})
	local p2 = vim.api.nvim_buf_get_extmark_by_id(0, Ns_id, m2, {})
	return p1[1] == p2[1] and p1[2] == p2[2]
end

local function move_to_mark(id)
	local new_cur_pos
	new_cur_pos = vim.api.nvim_buf_get_extmark_by_id(
		0, Ns_id, id, {details = false})
	set_cursor_0ind(new_cur_pos)
end

local function normal_move_to_mark(id)
	local new_cur_pos = vim.api.nvim_buf_get_extmark_by_id(
		0, Ns_id, id, {details = false})
	-- +1: indexing
	vim.api.nvim_feedkeys(tostring(new_cur_pos[1]+1)..'G^'..tostring(new_cur_pos[2])..'l', 'n', true)
end

return {
	get_cursor_0ind = get_cursor_0ind,
	set_cursor_0ind = set_cursor_0ind,
	move_to_mark = move_to_mark,
	normal_move_to_mark = normal_move_to_mark,
	remove_n_before_cur = remove_n_before_cur,
	get_current_line_to_cursor = get_current_line_to_cursor,
	mark_pos_equal = mark_pos_equal
}