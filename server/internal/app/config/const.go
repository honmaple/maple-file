package config

const (
	ApplicationPath = "app.path"

	ServerAddr      = "server.addr"
	ServerSecretKey = "server.secret_key"
	DatabaseDSN     = "database.dsn"
	DatabaseEcho    = "database.echo"

	LoggerLevel         = "logger.level"
	LoggerOutput        = "logger.output"
	LoggerTimestamp     = "logger.timestamp"
	LoggerFile          = "logger.file"
	LoggerFileMaxAge    = "logger.file_max_age"
	LoggerFileMaxSize   = "logger.file_max_size"
	LoggerFileMaxBackup = "logger.file_max_backup"
)

var defaultConfig = map[string]any{
	LoggerLevel:         "debug",
	LoggerOutput:        "stderr",
	LoggerTimestamp:     true,
	LoggerFile:          "server.log",
	LoggerFileMaxAge:    30,
	LoggerFileMaxSize:   100,
	LoggerFileMaxBackup: 3,

	ServerAddr:  "unix://server.sock",
	DatabaseDSN: "sqlite://server.db",
}
