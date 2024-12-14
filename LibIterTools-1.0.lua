assert(LibStub, "LibStub not found.");

---@alias LibIterTools-1.0 LibIterTools
local major, minor = "LibIterTools-1.0", 1;

---@class LibIterTools
local LibIterTools = LibStub:NewLibrary(major, minor);

if not LibIterTools then
    return;
end

------------
--- generic iterators

---@param tbl table
---@param iter? fun(tbl: table, key: any): any, any Used for iteration over the table or dataset
---@param predicate? fun(value: any): boolean Used to filter the output
function LibIterTools.Iterate(tbl, iter, predicate)
    iter = iter or next;
    predicate = predicate or function(...) return true; end;

    local key;
    return function()
        local value;
        repeat
            key, value = iter(tbl, key);
        until key == nil or predicate(value);
        return value;
    end
end

------------
--- utility iterators?

---@param start number
---@param stop? number
---@param step? number
function LibIterTools.Count(start, stop, step)
    step = step or 1;
    local i = 0;
    return function()
        local number = start + step * i;
        if number > stop then
            return;
        end

        i = i + 1;
        return number;
    end
end

---@param sequence table | string A sequence to cycle through
---@param cycles? number Number of times to cycle through the sequence
function LibIterTools.Cycle(sequence, cycles)
    local function GetNext(t, k)
        if type(t) == "table" then
            local key, value = next(t, k);
            if key == nil then
                return next(t);
            else
                return key, value;
            end
        else
            if k == nil then
                k = 0;
            end
            local i = k + 1;
            if i > #t then
                i = 1;
            end
            return i, strsub(t, i, i);
        end
    end

    local key;
    local iteration = 0;
    local maxSteps = #sequence * cycles;
    return function()
        iteration = iteration + 1;
        if iteration > maxSteps then
            return;
        end

        local value;
        key, value = GetNext(sequence, key);
        return value;
    end
end

---@param value any
---@param n number Number of times to repeat 'value'
function LibIterTools.Repeat(value, n)
    local i = 0;
    return function()
        i = i + 1;
        if i > n then
            return;
        end
        return value;
    end
end

---@param array table
---@param func function
function LibIterTools.Accumulate(array, func)
    func = func or function(a, b) return a + b end;

    local key;
    local total = 0;
    return function()
        local value;
        key, value = next(array, key);
        if key == nil then
            return;
        end

        total = total + value;
        return total;
    end
end

---@param array table
---@param batchSize number
function LibIterTools.Batch(array, batchSize)
    local i = 0;
    local n = #array;
    return function()
        i = i + 1;
        if i > n then
            return;
        end

        local tbl = {};
        for k=i, i + batchSize do
            tinsert(tbl, array[k]);
        end
        i = i + batchSize;
        return tbl;
    end
end