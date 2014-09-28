_cfg = dict(
    redis_host = "localhost",
    redis_port = 6379
)

def cfg(k):
    return _cfg.get(k, nil)
