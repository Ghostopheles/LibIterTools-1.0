# LibIterTools-1.0
LibIterTools is a small lib containing iterations tools used for iteration over various types of things.

## Basic Usage

```lua
---@type LibIterTools
local LibIterTools = LibStub:GetLibrary("LibIterTools-1.0");

-- count up from 1 to 10
for n in LibIterTools.Count(1, 10) do
    print(n);
end
-- prints 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

-- cycle over a string
local sequence = "ABCD";
local cycles = 4
for n in LibIterTools.Cycle(sequence, cycles) do
    print(n);
end
-- prints A, B, C, D, A, B, C, D, A, B, C, D...
```

## Advanced Usage
LibIterTools also provides a function that allows you to define your own iterator and predicate that will be used when iterating over the provided data.

You can use the iterator to grab data from somewhere other than a table, if necessary, or use the predicate to filter out values that you want to ignore.

```lua
-- using another function to generate data dynamically based on the provided key
local function GetNext(tbl, key)
    local k, v = MyAddon.GenerateDataForKey(key);
    return k, v;
end

-- use the predicate to filter out unwanted values
local function Predicate(value)
    return value ~= "Meorawr"; 
end

local InitialData = {
    "Charmander",
    "Bulbasaur",
    "Gengar",
    "Pikachu"
};
for element in LibIterTools.Iterate(InitialData, GetNext, Predicate) do
    print(element);
end
```