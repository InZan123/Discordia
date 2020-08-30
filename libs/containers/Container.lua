local class = require('../class')

local clients = {}

local Container, get = class('Container')

function Container:__init(client)
	clients[self] = assert(client)
end

-- TODO: toString methods

function Container.__eq()
	return error('__eq not implemented')
end

function Container.__hash()
	return error('__hash not implemented')
end

function Container._update()
	return error('_update not implemented')
end

function get:client()
	return clients[self]
end

return Container
