raw_config = File.read(RAILS_ROOT + "/config/psdbconfig.yml")
PSDB_CONFIG = YAML.load(raw_config)

