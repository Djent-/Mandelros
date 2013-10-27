--[[
Patrick Hurd
October 26th 2013 CE - October 27th 2013 CE
]]

function DEC_HEX(IN) -- http://lua-users.org/lists/lua-l/2004-09/msg00054.html
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B),math.mod(IN,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
    return OUT
end

function load()
	xmin = -3
	ymin = -1.25
	w = 5
	h = 2.5
	xmax = xmin + w
	ymax = ymin + h
	iters = 45
	zoom = 1
	offx = -50
	offy = 0
	step = 0.008
end

function mloadP()
	load()
	dw = application:getDeviceWidth()
	dh = application:getDeviceHeight()
	dx = (xmax - xmin) / dw
	dy = (ymax - ymin) / dh
	mandelbrot()
end

function mloadL()
	load()
	dh = application:getDeviceWidth()
	dw = application:getDeviceHeight()
	dx = (xmax - xmin) / dw
	dy = (ymax - ymin) / dh
	mandelbrot()
end

function mdraw(t,u,v,w)
	dec = tonumber("0x".. DEC_HEX(t) .. DEC_HEX(u) .. DEC_HEX(v))
	pixel = Shape.new()
	pixel:setLineStyle(1,dec,1)
	pixel:beginPath()
	if dh == application:getDeviceWidth() then
		pixel:lineTo(ZtoXandYL(w))
	else
		pixel:lineTo(ZtoXandY(w))
	end
	pixel:closePath()
	pixel:endPath()
	stage:addChild(pixel)
end

function mandelbrot()
	local step1 = 0.097
	local step2 = 0.180
	local step3 = 0.362
	local step4 = 0.65
	local y = ymin
	local d = 0
	for o = 0, dh do
		local x = xmin
		for p = 0, dw do
			local a = x
			local b = y
			local n = 0
			while n < iters do -- same as iterations_at
				local aa = a^2
				local bb = b^2
				local t = 2*a*b
				a = a^2 - b^2 + x
				b = t + y
				if aa + bb > 16 then
					break
				end
				n = n + 1
			end -- end
			if n == iters then				
				mdraw(0,0,0,d)
				d = d + 1
			else
				if n >= 0 and n < iters*step1 then			
					mdraw((n*18) % 255,0,0,d)
				elseif n >= iters*step1 and n < iters*step2 then				
					mdraw((n*18) % 255,(n*18) % 255,0,d)
				elseif n >= iters*step2 and n < iters*step3 then			
					mdraw(0,(n*18) % 255,0,d)
				elseif n >= iters*step3 and n < iters*step4 then			
					mdraw(0,0,(n*18) % 255,d)
				else			
					mdraw((n*18) % 255,0,(n*18) % 255,d)
				end
				d = d + 1
			end
			x = x + dx
		end
		y = y + dy
	end
	print("Done")
end

function ZtoXandY(z)
	local x,y = 1,1
	while z > dh - 1 do z = z - dh - 1; y = y + 1 end
	x = z
	return x,y
end

function ZtoXandYL(z)
	local x,y = 0,0
	while z > dw - 1 do z = z - dw - 1; y = y + 1 end
	x = z
	return y,x
end

mloadL()
