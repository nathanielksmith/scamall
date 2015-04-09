_cfg = dict(
    redis_host = "localhost",
    redis_port = 6379,
    mongo_host = "localhost",
    mongo_port = 27017,
    mongo_dbname = "scamall",
    mongo_collection = "test"

)

def cfg(k):
    return _cfg.get(k, None)
