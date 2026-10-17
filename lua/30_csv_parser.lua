-- =============================================================================
-- Exercise 30: CSV Table Parser & Query Filter
-- Concepts: String parsing, quote escaping, tabular records,
--           column lookups, and row query filtering.
-- Run:      lua 30_csv_parser.lua
-- =============================================================================

local CSVTable = {}
CSVTable.__index = CSVTable

function CSVTable.new()
    return setmetatable({ headers = {}, rows = {} }, CSVTable)
end

-- Parses a single CSV line while properly handling quoted fields containing commas
local function parseCSVLine(line)
    local fields = {}
    local current = ""
    local inQuotes = false

    for i = 1, #line do
        local ch = line:sub(i, i)
        if ch == '"' then
            inQuotes = not inQuotes
        elseif ch == ',' and not inQuotes then
            table.insert(fields, current)
            current = ""
        else
            current = current .. ch
        end
    end
    table.insert(fields, current)
    return fields
end

-- Loads a multi-line CSV string into headers and structured row records
function CSVTable:load(csvContent)
    self.headers = {}
    self.rows = {}

    local lines = {}
    for line in csvContent:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    if #lines == 0 then return end

    self.headers = parseCSVLine(lines[1])
    for i = 2, #lines do
        table.insert(self.rows, { fields = parseCSVLine(lines[i]) })
    end
end

-- Finds the 1-based index of a column by header name (-1 if not found)
function CSVTable:getColumnIndex(colName)
    for i, h in ipairs(self.headers) do
        if h == colName then
            return i
        end
    end
    return -1
end

local function main()
    local csvData = "name,department,salary\n" ..
                    "Alice,Engineering,95000\n" ..
                    "\"Bob, Jr.\",Marketing,62000\n" ..
                    "Charlie,Engineering,105000\n" ..
                    "Diana,Design,78000\n"

    local tbl = CSVTable.new()
    tbl:load(csvData)

    local deptIdx = tbl:getColumnIndex("department")
    local nameIdx = tbl:getColumnIndex("name")
    local salaryIdx = tbl:getColumnIndex("salary")

    print(string.format("CSV Table Loaded (%d columns, %d rows)", #tbl.headers, #tbl.rows))
    print("--- Engineering Staff ---")

    for _, row in ipairs(tbl.rows) do
        if row.fields[deptIdx] == "Engineering" then
            print(string.format("- %s (Salary: $%s)", row.fields[nameIdx], row.fields[salaryIdx]))
        end
    end
end

main()
