local tarot = {}
tarot.version = "1.0.0"

local stack = require("lib.tarot.stack")

local stacks = {}
local grabbed = nil

function tarot.mk_stack(id,x,y,limit,spread_angle)
    stacks[id] = stack:new{x=x,y=y, limit=limit, spread_angle=spread_angle}
end

function tarot.get_stack(id)
    return stacks[id]
end

function tarot.draw()
    for id,stack_obj in pairs(stacks) do
            stack_obj:draw()
    end
    if grabbed then
        grabbed:draw()
    end
end

function tarot.mousepressed(x, y, button, istouch)
   if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
    for stack_id, stack_obj in pairs(stacks) do
        for card_obj, is_grabbable in pairs(stack_obj.contents) do
            if is_grabbable then
                if ( x > card_obj.x and x < (card_obj.x+card_obj.width) and y > card_obj.y and y < (card_obj.y+card_obj.height)) then
                    grabbed = card_obj
                end
            end
        end
    end
   end
end

function tarot.mousereleased(x, y, button, istouch, presses)
   if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
    if grabbed then
        if grabbed.snapped_object then
            grabbed:set_stack(grabbed.snapped_object)
        end
        grabbed:clear_snapped()
        grabbed:goto_anchor()
        grabbed = nil
    end
   end
end

function tarot.mousemoved( x, y, dx, dy, istouch )
    if grabbed then
        grabbed:set_pos(grabbed.x+dx, grabbed.y+dy)
        if grabbed.snapped_object then
            if not grabbed.snapped_object:try_snap(grabbed) then
                grabbed:clear_snapped()
            end
        else
            for stack_id, stack_obj in pairs(stacks) do
                stack_obj:try_snap(grabbed)
            end
        end

    end
end

return tarot