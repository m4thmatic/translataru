--[[
* Addons - Copyright (c) 2021 Ashita Development Team
* Contact: https://www.ashitaxi.com/
* Contact: https://discord.gg/Ashita
*
* This file is part of Ashita.
*
* Ashita is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Ashita is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Ashita.  If not, see <https://www.gnu.org/licenses/>.
--]]

addon.author   = 'Mathmatic';
addon.name     = 'translataru';
addon.desc     = 'Convert text in double brackets [[ ]] to autotranslate messages';
addon.version  = '1.0';

local autoDict = require('dictionary');

local function autotranslateBytes(id)
    local hexValue = string.format("%04X", id) -- Format ID as a 4-digit hex
    local highByte = tonumber(hexValue:sub(1, 2), 16) -- Get the high byte
    local lowByte = tonumber(hexValue:sub(3, 4), 16) -- Get the low byte
    return string.char(0xFD, 0x02, 0x02, highByte, lowByte, 0xFD) --Autotranslator message
end

--------------------------------------------------------------------
ashita.events.register('text_out', 'text_in_cb', function (e)
    --Search for anything inside a triple [[ ]]
    local regexPattern = "%[%[(.-)%]%]";

    -- Search for the dictionary with a matching English value
    -- If found, replace [[[msg]]] with the proper byte code to display the autotranslator message
    -- Otherwise return the original text
    local output = e.message:gsub(regexPattern, function(match)
        for _, entry in pairs(autoDict) do
            --if (entry.en:lower() == match:lower()) or (entry.ja == match) then
            if (entry.en:lower() == match:lower()) then --case insensitive
                return autotranslateBytes(entry.id)
            end
            
            --if (entry.ja == match) then
            --    return autotranslateBytes(entry.id)
            --end
        end
        return "[[" .. match .. "]]"
    end)
   
    e.message_modified = output
end);