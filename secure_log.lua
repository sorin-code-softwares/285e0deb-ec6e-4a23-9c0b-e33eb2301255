-- SecureLog: encrypts log text locally so only the holder of the RSA private key can decrypt.
-- Fill in PUBLIC_KEY (PEM) before use. Expected provider: syn.crypt or crypt.*

local HttpService = game:GetService("HttpService")

local PUBLIC_KEY = [[
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA02H8E2aAytfIeBjxmzxH
EGO9Xc7cscEoQS+OXYGedZDzAUaEuVqb1Ol9wKTIUscAAMX8xAtRWsjpxQOLtEVn
XTYZYtzlkx1L8Dqf0/Pv7VGxG9jPESRDggYFFMz7QnwODZhkxsg1Ww3SnhCANmXn
eb9vAG3V+hneatmssj/czfQGzcYxHQaUj6R7aEu7gMxVlAei/IjZya0AB+QbLf5l
o6FjcJ6MAfHrfpfvmo+priYbDthaKCdE7Wo3wp6h44fBR5q3X0tNcxc3qqSwsZ4h
ZF5MrcCSPT0LkQtiQdzZ92zTc7q6erfsSuUJ1lH6M2p9TE48DtUPEnRap/arX6RC
KwIDAQAB
-----END PUBLIC KEY-----
]]

-- PKCS7 padding (AES block size 16)
local function pkcs7Pad(text, blockSize)
	blockSize = blockSize or 16
	local padLen = blockSize - (#text % blockSize)
	return text .. string.rep(string.char(padLen), padLen)
end

-- Simple base64 fallback
local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function b64encode(data)
	local bytes = { data:byte(1, #data) }
	local result = {}
	for i = 1, #bytes, 3 do
		local a = bytes[i] or 0
		local b = bytes[i + 1] or 0
		local c = bytes[i + 2] or 0

		-- combine to 24 bits without bit operators (Luau-compat)
		local triple = a * 65536 + b * 256 + c
		local idx1 = math.floor(triple / 262144) % 64          -- 2^18
		local idx2 = math.floor(triple / 4096) % 64            -- 2^12
		local idx3 = math.floor(triple / 64) % 64              -- 2^6
		local idx4 = triple % 64

		table.insert(result, b64chars:sub(idx1 + 1, idx1 + 1))
		table.insert(result, b64chars:sub(idx2 + 1, idx2 + 1))
		if bytes[i + 1] then
			table.insert(result, b64chars:sub(idx3 + 1, idx3 + 1))
		else
			table.insert(result, "=")
		end
		if bytes[i + 2] then
			table.insert(result, b64chars:sub(idx4 + 1, idx4 + 1))
		else
			table.insert(result, "=")
		end
	end
	return table.concat(result)
end

-- Detect crypto provider
local function getProvider()
	-- syn.crypt
	if syn and syn.crypt then
		local c = syn.crypt
		local b64 = (c.base64 and (c.base64.encode or c.base64.enc)) or b64encode
		local rand = c.random or c.generatebytes or c.generatekey
		local rsaEnc = c.rsa and c.rsa.encrypt
		local aesEnc = c.encrypt
		if rand and rsaEnc and aesEnc then
			return {
				random = rand,
				b64 = b64,
				rsaEncrypt = function(pub, data) return rsaEnc(data, pub) end,
				aesCbcEncrypt = function(key, iv, data) return aesEnc(data, key, iv, "aes-256-cbc") end,
			}
		end
	end
	-- generic crypt
	if crypt then
		local b64 = (crypt.base64 and crypt.base64.encode) or crypt.base64encode or b64encode
		local rand = crypt.generatebytes or crypt.random or crypt.generatekey
		local rsaEnc = crypt.rsa and crypt.rsa.encrypt
		local aesEnc
		if crypt.aes and crypt.aes.encrypt then
			aesEnc = function(key, iv, data) return crypt.aes.encrypt(data, key, iv) end
		elseif crypt.encrypt then
			aesEnc = function(key, iv, data) return crypt.encrypt(data, key, iv, "aes-256-cbc") end
		end
		if rand and rsaEnc and aesEnc then
			return {
				random = rand,
				b64 = b64,
				rsaEncrypt = function(pub, data) return rsaEnc(data, pub) end,
				aesCbcEncrypt = function(key, iv, data) return aesEnc(key, iv, data) end,
			}
		end
	end
	return nil
end

local provider = getProvider()
if not provider then
	error("No supported crypto provider found (syn.crypt or crypt required).")
end

local SecureLog = {}

-- SecureLog.write(logText, { filename = "errorlog_x.sec" })
function SecureLog.write(logText, options)
	options = options or {}
	if not PUBLIC_KEY:find("BEGIN PUBLIC KEY") then
		error("PUBLIC_KEY not set in SecureLog.")
	end
	local filename = options.filename or ("errorlog_" .. os.time() .. ".sec")

	local aesKey = provider.random(32)
	local iv = provider.random(16)
	local cipher = provider.aesCbcEncrypt(aesKey, iv, pkcs7Pad(logText, 16))
	local encKey = provider.rsaEncrypt(PUBLIC_KEY, aesKey)

	local payload = {
		key = provider.b64(encKey),
		iv = provider.b64(iv),
		data = provider.b64(cipher),
		mode = "aes-256-cbc",
		created = os.time(),
	}
	local json = HttpService:JSONEncode(payload)
	writefile(filename, json)
	return filename
end

return SecureLog
