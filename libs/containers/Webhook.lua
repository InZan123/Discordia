local Snowflake = require('./Snowflake')
local User = require('./User')

local class = require('../class')
local typing = require('../typing')
local json = require('json')

local checkType, checkImage = typing.checkType, typing.checkImage

local Webhook, get = class('Webhook', Snowflake)

function Webhook:__init(data, client)
	Snowflake.__init(self, data, client)
	self._channel_id = data.channel_id
	self._guild_id = data.guild_id
	self._application_id = data.application_id
	self._token = data.token
	return self:_load(data)
end

function Webhook:_load(data)
	self._type = data.type
	self._name = data.name
	self._avatar = data.avatar
	self._user = data.user and User(data.user, self.client) or nil
	-- TODO: data.source_channel and data.source_guild
end

function Webhook:_modify(payload)
	local data, err = self.client.api:modifyWebhook(self.id, payload)
	if data then
		self:_load(data)
		return true
	else
		return false, err
	end
end

function Webhook:getAvatarURL(size, ext)
	return User.getAvatarURL(self, size, ext)
end

function Webhook:getDefaultAvatarURL(size)
	return User.getDefaultAvatarURL(self, size)
end

function Webhook:setName(name)
	return self:_modify {name = name and checkType('string', name) or json.null}
end

function Webhook:setAvatar(avatar)
	return self:_modify {avatar = avatar and checkImage(avatar) or json.null}
end

function Webhook:delete()
	local data, err = self.client.api:deleteWebhook(self.id)
	if data then
		return true
	else
		return false, err
	end
end

function get:guildId()
	return self._guild_id
end

function get:channelId()
	return self._channel_id
end

function get:user()
	return self._user
end

function get:token()
	return self._token
end

function get:name()
	return self._name
end

function get:type()
	return self._type
end

function get:avatar()
	return self._avatar
end

function get.defaultAvatar()
	return 0
end

function get:applicationId()
	return self._application_id
end

return Webhook
