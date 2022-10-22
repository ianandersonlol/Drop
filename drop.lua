--[[Copyright © 2021, Arico
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of <addon name> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <your name> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. --]]

_addon.name = 'Drop'
_addon.author = 'Arico'
_addon.version = '1.5'
_addon.command = 'drop'

res_items = require('resources').items
packets = require('packets')
require('luau')
require('logger')

windower.register_event('load', function(...)
    for k,v in pairs(res_items) do
        item_names[string.lower(v.english)] = {id = k}
    end
end)

drop_item = function(item_to_drop) 
    for k, v in pairs(windower.ffxi.get_items().inventory) do
        if type(v) == "table" and v.id and v.id > 0 and res_items[v.id].name:lower() == item_to_drop then
                local drop_packet = packets.new('outgoing', 0x028, {
                    ["Count"] = v.count,
                    ["Bag"] = 0,
                    ["Inventory Index"] = k,
                })
                packets.inject(drop_packet)
                coroutine.sleep(.1)
            end
        end
    end     

windower.register_event('addon command', function (...)
    args = {...};
    if not args[1] or (args[1] and args[1]:lower() == 'help') then
        log('//drop <\30\02name of item\30\01>\nDrops a specific \30\02item\30\01. Does not require quotes, capitalization, and accepts auto-translate.') 
        return
    end
    
    if args[1] then
        args[1] = windower.convert_auto_trans(args[1])
    end
    
    local item = table.concat(args, ' ',1,#args):lower()

    if item then
        if item_names[item] == nil
            item = string.gsub(" "..item, "%W%l", string.upper):sub(2)
            log(('No \30\02%s\30\01 was found in your inventory.':format(item)))
        else 	
            item = string.gsub(" "..item, "%W%l", string.upper):sub(2)
            log(('No \30\02%s\30\01 was found in your inventory.':format(item)))
        end
    end     
end)
