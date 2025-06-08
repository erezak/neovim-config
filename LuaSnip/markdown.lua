local ls = require("luasnip")
local s, t, f = ls.snippet, ls.text_node, ls.function_node

local function get_formatted_alias_date()
	-- Get the filename, which is assumed to be the date in YYYY-MM-DD format
	local filename_date_str = vim.fn.expand("%:t:r")

	-- Parse the year, month, and day from the filename
	local y_str, m_str, d_str = filename_date_str:match("^(%d%d%d%d)-(%d%d)-(%d%d)$")

	if not (y_str and m_str and d_str) then
		-- Return an empty string or a default if the filename doesn't match the expected date format
		print("Error: Could not parse date from filename for alias: " .. filename_date_str)
		return ""
	end

	local year = tonumber(y_str)
	local month = tonumber(m_str)
	local day = tonumber(d_str) -- This is the day number

	-- Create a date table for os.time(). Hour is required; midday is fine.
	local date_table = { year = year, month = month, day = day, hour = 12, min = 0, sec = 0 }
	local timestamp = os.time(date_table)

	if not timestamp then
		print("Error: Could not get timestamp for date: " .. filename_date_str)
		return ""
	end

	-- Format the date as "Month Day, Year" (e.g., "Jun 5, 2025")
	-- %b - abbreviated month name
	-- %Y - full year
	-- The 'day' variable is already the numeric day of the month.
	local month_abbr = os.date("%b", timestamp)
	local formatted_date_str = month_abbr .. " " .. day .. ", " .. year

	return formatted_date_str
end

local function wrap_text_to_width(text, width)
	if width <= 0 or text == nil or text == "" then
		return { text or "" }
	end
	local lines = {}
	local current_line = ""
	for word in string.gmatch(text, "[^%s]+") do -- Iterate over words
		if #current_line == 0 then
			current_line = word
		elseif #current_line + 1 + #word <= width then -- +1 for the space
			current_line = current_line .. " " .. word
		else
			table.insert(lines, current_line)
			current_line = word
		end
	end
	if #current_line > 0 then
		table.insert(lines, current_line)
	end
	return lines
end

local function parse_csv_line(line) -- From previous suggestion
	local fields = {}
	local current_pos = 1
	local current_field = ""
	local in_quotes = false

	-- Handle empty line
	if line == nil or line == "" then
		return fields
	end

	while current_pos <= #line do
		local char = line:sub(current_pos, current_pos)
		local next_char = (current_pos < #line) and line:sub(current_pos + 1, current_pos + 1) or nil

		if char == '"' then
			if in_quotes and next_char == '"' then
				-- Handle escaped double quote "" by adding one " to the field and skipping next char
				current_field = current_field .. '"'
				current_pos = current_pos + 1
			else
				-- Toggle in_quotes state. Don't add the quote char itself to current_field
				-- if it's a field quoting character, unless it's an escaped one.
				in_quotes = not in_quotes
			end
		elseif char == "," and not in_quotes then
			-- Delimiter found outside quotes, field complete
			table.insert(fields, current_field)
			current_field = "" -- Reset for next field
		else
			-- Regular character, add to current field
			current_field = current_field .. char
		end
		current_pos = current_pos + 1
	end

	-- Add the last field
	table.insert(fields, current_field)

	return fields
end

--[[
    NEW HELPER: Formats the quote data into lines for Luasnip
--]]
local function format_quote_output(quote_text, author_text, tags_list, wrap_width)
	quote_text = quote_text or "[Missing quote]"
	author_text = author_text or "Unknown"
	tags_list = tags_list or {} -- Expects a table of tag strings (without '#')

	local wrapped_quote_lines = wrap_text_to_width(quote_text, wrap_width)
	local blockquoted_lines_table = {}

	if #wrapped_quote_lines > 0 and not (#wrapped_quote_lines == 1 and wrapped_quote_lines[1] == "") then
		table.insert(blockquoted_lines_table, "> [!quote] " .. wrapped_quote_lines[1])
		for i = 2, #wrapped_quote_lines do
			table.insert(blockquoted_lines_table, "> " .. wrapped_quote_lines[i])
		end
	else
		table.insert(blockquoted_lines_table, "> [!quote] [Missing quote content]")
	end

	local blockquoted_content_str = table.concat(blockquoted_lines_table, "\n")

	-- Using your preferred spacing (with "> " line between quote and author)
	local formatted_str = blockquoted_content_str .. "\n>\n> -- " .. author_text .. "\n"

	if #tags_list > 0 then
		local individual_formatted_tags = {}
		for _, tag_item in ipairs(tags_list) do
			local trimmed_tag = vim.trim(tag_item)
			if #trimmed_tag > 0 then
				-- Ensure # prefix, replace spaces with underscores
				table.insert(individual_formatted_tags, "#" .. trimmed_tag:gsub("%s+", "_"))
			end
		end

		if #individual_formatted_tags > 0 then
			formatted_str = formatted_str .. "> "
			formatted_str = formatted_str .. table.concat(individual_formatted_tags, " ") .. "\n"
		end
	end

	-- Split the final formatted string into a list of lines for Luasnip
	local output_lines = {}
	for line_str in formatted_str:gmatch("([^\n]+)") do
		table.insert(output_lines, line_str)
	end
	if #output_lines > 0 and output_lines[#output_lines] == "" and formatted_str:sub(-1) == "\n" then
		table.remove(output_lines)
	end
	return output_lines
end

--[[
    Function to attempt fetching quote from API
--]]
local function attempt_api_quote(timeout_seconds, wrap_width)
	local quote_api_url = "http://api.quotable.io/random"
	local curl_cmd = string.format([[curl --max-time %d -s %s 2>/dev/null]], timeout_seconds, quote_api_url)

	local handle = io.popen(curl_cmd)
	local result = handle and handle:read("*a") or ""
	local status = handle and handle:close()

	if not result or result == "" then
		print("API call: No result or empty result from curl.")
		return nil -- Indicate failure
	end
	if status == nil or (type(status) == "table" and status.exit ~= 0) then
		print("API call: curl command failed or exited with error.")
		return nil
	end

	local ok, json_data = pcall(vim.fn.json_decode, result)
	if not ok or not json_data or type(json_data) ~= "table" then
		print("API call: Failed to decode JSON or invalid JSON structure.")
		return nil -- Indicate failure
	end

	if not json_data.content or not json_data.author then
		print("API call: JSON data missing content or author.")
		return nil -- Indicate failure
	end

	-- quotable.io returns tags as an array of strings
	local api_tags = json_data.tags or {}
	if type(api_tags) ~= "table" then
		api_tags = { tostring(api_tags) }
	end -- Ensure it's a table

	print("Successfully fetched quote from API.")
	return format_quote_output(json_data.content, json_data.author, api_tags, wrap_width)
end

--[[
    Function to fetch quote from local CSV (your existing logic, adapted to use the formatter)
--]]
local function fetch_quote_from_csv(wrap_width)
	local path = vim.fn.expand("~/Documents/quotes.csv") -- Your CSV file path
	local file = io.open(path, "r")
	if not file then
		print("CSV Fallback: Could not open file: " .. path)
		return format_quote_output("[No quotes available - file not found]", "System", {}, wrap_width)
	end
	local header = file:read("*l")
	if not header then
		file:close()
		return format_quote_output("[CSV file is empty or header missing]", "System", {}, wrap_width)
	end
	local lines_data = {}
	for line_content in file:lines() do
		table.insert(lines_data, line_content)
	end
	file:close()
	if #lines_data == 0 then
		return format_quote_output("[No quotes available after header]", "System", {}, wrap_width)
	end

	local target_line_content = lines_data[math.random(#lines_data)]
	if not target_line_content then
		return format_quote_output("[Failed to get random line from CSV]", "System", {}, wrap_width)
	end

	local fields = parse_csv_line(target_line_content)
	if #fields < 3 then
		print("CSV Fallback: Parsing failed for line: '" .. target_line_content .. "'")
		return format_quote_output("[Quote parsing error from CSV]", "System", {}, wrap_width)
	end

	local quote_text = fields[1]
	local author_text = fields[2]
	local tags_csv_string = fields[3] -- This is a comma-separated string of tags

	local csv_tags_list = {}
	if tags_csv_string and #tags_csv_string > 0 then
		for tag_part in string.gmatch(tags_csv_string, "([^,]+)") do
			table.insert(csv_tags_list, vim.trim(tag_part))
		end
	end

	print("Fetched quote from CSV.")
	return format_quote_output(quote_text, author_text, csv_tags_list, wrap_width)
end

--[[
    MAIN FUNCTION CALLED BY LUASNIP
--]]
local function fetch_quote()
	local start_time = os.clock()
	local wrap_width = 60 -- Centralized wrap_width

	math.randomseed(os.time()) -- If not done elsewhere

	local quote_lines = attempt_api_quote(1, wrap_width) -- 1 second timeout

	if not quote_lines then
		print("API attempt failed or timed out, falling back to local.")
		quote_lines = fetch_quote_from_csv(wrap_width)
	else
		print("API quote fetched successfully.")
	end

	local elapsed = os.clock() - start_time
	print(string.format("fetch_quote (total) took %.3f seconds", elapsed))

	return quote_lines
end

return {
	s("dailynote", {
		t({ "---", "id: " }),
		f(function()
			return vim.fn.expand("%:t:r")
		end, {}),
		t({ "", "aliases:", "" }),
		f(function()
			local alias_date_str = get_formatted_alias_date() -- Call the new helper
			if alias_date_str ~= "" then
				-- Return the formatted alias as a YAML list item
				-- Ensure proper quoting for YAML strings if they might contain special chars,
				-- though this date format is usually safe.
				return { "  - " .. alias_date_str .. "" }
			else
				return { "  - []" } -- Fallback to empty list item or just "[]"
			end
		end, {}),
		t({ "", "tags:", "  - daily-notes", "---", "" }), -- Ensure tags are also properly indented if that's your style

		f(fetch_quote, {}),
		t(""),
		-- only include the following line if the file is in the work (or Work) folder
		f(function()
			local containing_dir = vim.fn.expand("%:p:h")
			if containing_dir:match("/work/") then
				return { "", "", "## Meetings", "", "-", "" }
			else
				return { "" }
			end
		end, {}),

		t({ "", "## Scratchpad", "", "" }),
	}),
}
