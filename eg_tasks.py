from celery import Celery
from redis import StrictRedis
import requests

from cfg import cfg

app = Celery('crawl', broker='redis://localhost:6379')

@app.task
def add(x, y):
	print('add called')
	return x + y

@app.task
def process(url):
    r = requests.get(url)
