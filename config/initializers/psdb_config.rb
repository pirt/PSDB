raw_config = File.read(RAILS_ROOT + "/config/psdbconfig.yml")
PSBDB_CONFIG = YAML.load(raw_config)

