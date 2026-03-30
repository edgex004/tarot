local function drawOriginCenteredText(text)
	local font       = love.graphics.getFont()
	local textWidth  = font:getWidth(text)
	local textHeight = font:getHeight()
	love.graphics.print(text, 0, 0, 0, 1, 1, textWidth/2, textHeight/2)
end

local card = {}
card.version = "1.0.0"

function card:new (o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    self.front_text = "front"
    self.back_text = "back"
    self.x = 0
    self.y = 0
    self.theta = 0
    self.anchor_x = 0
    self.anchor_y = 0
    self.anchor_theta = 0
    self.width = 100
    self.height = 175
    self.color = {0.5,0.5,0.6,1.0}
    self.border_color = {0.9,0.9,0.9,1.0}
    self.up =true
    self.border=5
    self.image = nil 
    o.snapped_object = nil
    o.stack=nil
    return o
end

function card:set_pos (x,y,theta)
    self.x = x
    self.y = y
    self.theta = theta or 0
end

function card:set_snapped (object)
    self.snapped_object = object
end

function card:clear_snapped ()
    self.snapped_object = nil
end

function card:set_stack(new_stack)
    if not new_stack:add(self) then
        return false
    end
    if self.stack then
        self.stack:remove(self)
    end
    self.stack = new_stack
    return true
end

function card:set_anchor (x,y,theta)
    self.anchor_x = x
    self.anchor_y = y
    self.anchor_theta = theta or 0
end

function card:goto_anchor()
    self.x = self.anchor_x
    self.y = self.anchor_y
    self.theta = self.anchor_theta
    end

function card:set_size (width,height)
    self.width = width
    self.height = height
end

function card:set_up (up)
    self.up = up
end

function card:setColor (rgba)
    self.color = rgba
end

function card:drawRotated(x, y, w, h, angle)
	love.graphics.push()
		love.graphics.translate(x+w/2, y+h/2)
		love.graphics.rotate(angle)
        love.graphics.setColor( self.border_color )
		-- love.graphics.rectangle("fill", -w/2-self.border, -h/2-self.border, w+2*self.border, h+2*self.border,self.border, self.border)
		love.graphics.rectangle("fill", -w/2-self.border, -h/2-self.border, w+2*self.border, h+2*self.border)
        love.graphics.setColor( self.color )
		love.graphics.rectangle("fill", -w/2, -h/2, w, h)
        if self.image then
            love.graphics.setColor( {1,1,1,1} )

            love.graphics.draw(self.image, -w/2, -h/3, 0, w/self.image:getWidth(), w/self.image:getWidth())
            -- love.graphics.draw(self.image, 0,0)
        end
        love.graphics.setColor( {0,0,0,1} )
        local text = (self.up) and self.front_text or self.back_text
		love.graphics.translate(0, -3*h/7)
        drawOriginCenteredText(text)
	love.graphics.pop()
end

function card:draw ()
    self:drawRotated(   self.snapped_object and self.snapped_object.x or self.x,
                        self.snapped_object and self.snapped_object.y or self.y,
                        self.width, self.height,
                        self.snapped_object and 0 or self.theta)
end

return card