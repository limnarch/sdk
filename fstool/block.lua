-- block interface

-- allows creation of block device objects
-- which are an abstraction on files

local block = {}

function block.new(image, blocksize, offset)
	local bd = {}

	offset = offset or 0

	bd.bs = blocksize

	bd.file = io.open(image, "rb+")

	if not bd.file then return false end

	bd.size = bd.file:seek("end") - (offset * blocksize)

	bd.blocks = math.floor(bd.size / blocksize) - offset

	function bd:seek(block)
		self.file:seek("set", (block * self.bs) + (offset * self.bs))
	end

	function bd:read()
		return string.byte(self.file:read(1))
	end

	function bd:write(byte)
		self.file:write(string.char(byte))
	end

	function bd:readBlock(block)
		if block > self.blocks then
			error(string.format("read %x", block))
		end

		local b = {}

		self.file:seek("set", (block * self.bs) + (offset * self.bs))

		for i = 0, self.bs - 1 do
			b[i] = string.byte(self.file:read(1) or "\0")
		end

		return b
	end

	function bd:writeBlock(block, b)
		if block > self.blocks then
			error(string.format("write %x", block))
		end

		self.file:seek("set", (block * self.bs) + (offset * self.bs))

		for i = 0, self.bs - 1 do
			self.file:write(string.char(b[i] or 0))
		end
	end

	function bd:close()
		self.file:close()
	end

	return bd
end

return block