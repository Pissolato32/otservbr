-- Server identity
serverName = os.getenv("SERVER_NAME") or "MyOTServer"
ip = os.getenv("SERVER_IP") or "127.0.0.1"
bindOnlyGlobalAddress = false

-- Client version
clientVersionMin = 860
clientVersionMax = 860

-- Map
mapName = "data/world/forgotten"
mapAuthor = "OTLand"

-- Database
sqlType = "mysql"
sqlHost = os.getenv("MYSQL_HOST") or "db"
sqlPort = 3306
sqlUser = os.getenv("MYSQL_USER") or "tibia"
sqlPass = os.getenv("MYSQL_PASSWORD") or "yourpassword"
sqlDatabase = os.getenv("MYSQL_DATABASE") or "tibia"

-- Ports
loginProtocolPort = tonumber(os.getenv("LOGIN_PORT")) or 7171
gameProtocolPort = tonumber(os.getenv("GAME_PORT")) or 7172
statusProtocolPort = tonumber(os.getenv("STATUS_PORT")) or 7171

-- Account manager
accountManager = true
namelockManager = true
newPlayerChooseVoc = false
newPlayerSpawnPosX = 1000
newPlayerSpawnPosY = 1000
newPlayerSpawnPosZ = 7
newPlayerTownId = 1
newPlayerLevel = 1
newPlayerMagicLevel = 0
generateDescr = false

-- Limits
maxPlayers = 1000
maxPacketsPerSecond = 200

-- Rates
rateExp = 10
rateSkill = 10
rateLoot = 2
rateMagic = 5
rateSpawn = 1

-- PVP
worldType = "open"
protectionLevel = 8
killsToRedSkull = 3
pzLocked = 60000
whiteSkullTime = 15 * 60 * 1000
redSkullLength = 30 * 24 * 60 * 60
