require("mysqloo")

include("sql_config.lua")
local tbl = SQL
	
db = mysqloo.connect(tbl.Host, tbl.User, tbl.Pass, tbl.Name, tbl.Port)
local qu = {}

function query(sSQL, callback)
	callback = callback or function() end
	local q = db:query(sSQL)
	function q:onSuccess(data)
		callback(data)
	end

	function q:onError(err, sSQL)
		print(err)
	end

	q:start()
end
	
function db:onConnected()
	hook.Call("DBConnected")

	connected = true

	print("Connected successfully to external db!")
end

function db:onConnectionFailed(err)
	print("Failed to connect (sad face :()", err)
end

db:connect()

function escape(string, quotes)
	return db:escape(string)
end

hook.Add('DBConnected', 'Initializedatabase', function()
	query([[
		CREATE TABLE IF NOT EXISTS `playerdata` (
		  `id` varchar(50) DEFAULT NULL,
		  `class` varchar(50) DEFAULT NULL,
		  `classes_owned` varchar(300) DEFAULT NULL,
		  `money` INT NULL DEFAULT 0,
	   	  `achievements` VARCHAR(2000) NULL DEFAULT NULL,
		) ENGINE=MyISAM DEFAULT CHARSET=utf8;]])
end)