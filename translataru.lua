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
addon.version  = '1.1';

local autoDict = require('dictionary');
local encode = require('encoding');

local function autotranslateBytes(id)
    local hexValue = string.format("%04X", id) -- Format ID as a 4-digit hex
    local highByte = tonumber(hexValue:sub(1, 2), 16) -- Get the high byte
    local lowByte = tonumber(hexValue:sub(3, 4), 16) -- Get the low byte
    return string.char(0xFD, 0x02, 0x02, highByte, lowByte, 0xFD) --Autotranslator message
end

--------------------------------------------------------------------
ashita.events.register('text_out', 'text_in_cb', function (e)

    --Search for anything inside a double [[ ]]
    local regexPattern = "%[%[(.-)%]%]";

    local output = e.message:gsub(regexPattern, function(keyStr)
        if autoDict.english[keyStr:lower()] then --Check for English match (case insensitive)
            return autotranslateBytes(autoDict.english[keyStr:lower()]);
        elseif autoDict.japanese[keyStr] then --Check for Japanese match
            return autotranslateBytes(autoDict.japanese[keyStr]);
        else
            return keyStr
        end
    end)

    e.message_modified = output
end);