local stack = {}
stack.version = "1.0.0"

local card = require("lib.tarot.card")

function stack:new (o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    self.x = 0
    self.y = 0
    self.width = 100
    self.height = 175
    self.color = {0.2,0.2,0.2,1.0}
    self.limit = 5
    self.snap_distance = 60
    self.spread_distance = 120
    self.spread_angle = 0.1
    o.size = 0
    o.contents = {}
    return o
end

function stack:add(card_ref)
    if self.size >= self.limit then
        return false
    end
    if not self.contents[card_ref] then
        self.size = self.size+1
    end
    self.contents[card_ref] = true
    self:shape_contents()
    return true
end

function stack:mk_card(text, image, color)
    local new_card = card:new{front_text=text, color=color, image=image}
    new_card:set_stack(self)
end


function stack:remove (card_ref)
    if self.contents[card_ref] then
        self.size = self.size-1
    end
    self.contents[card_ref] = nil
    self:shape_contents()
end

function stack:set_pos (x,y)
    self.x = x
    self.y = y
end

function stack:set_size (width,height)
    self.width = width
    self.height = height
end

function stack:set_up (up)
    self.up = up
end

function stack:setColor (rgba)
    self.color = rgba
end

function stack:shape_contents()
    local i = 0
    for object,should_draw in pairs(self.contents) do
        local alpha = math.ceil(self.size/2 - self.size) + i
        object:set_pos(self.x+alpha*self.spread_distance, self.y, alpha*self.spread_angle)
        object:set_anchor(self.x+alpha*self.spread_distance, self.y, alpha*self.spread_angle)
        i=i+1
    end
end

function stack:try_snap(card)
    if self.size>=self.limit then
        return false
    end
    if self.contents[card] then
        return false
    end
    if math.abs(card.x-self.x) < self.snap_distance and math.abs(card.y-self.y) < self.snap_distance then
        card:set_snapped(self)
        return true
    end
    return false
end

function stack:get_cards()
    return self.collection()
end

function stack:draw ()
    -- if self.size == 0 then
        love.graphics.setColor( self.color )
        love.graphics.rectangle( "fill", self.x, self.y, self.width, self.height) --, rx, ry, segments )
    -- else
        for object,should_draw in pairs(self.contents) do
            object:draw()
        end
    -- end

end

return stack