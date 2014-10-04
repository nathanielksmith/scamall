(import [contextlib [closing]])
(import [datetime [datetime]])
(import [functools [partial]])
(import re)
(import [urllib.parse [urlparse]])

(import [celery [Celery]])
(import [prosaic.nyarlathotep [process-txt!]])
(import [pymongo [MongoClient]])
(import [redis [StrictRedis]])
(import requests)

(import [scamall.cfg [cfg]])

(def *celery* (apply Celery ["crawl"] {"broker" (.format "redis://{}:{}" (cfg "redis_host") (cfg "redis_port"))}))
(def *redis*  (StrictRedis (cfg "redis_host") (cfg "redis_port")))
(def *mongo*  (MongoClient (cfg "mongo_host") (cfg "mongo_port")))
(def *db*     (. *mongo* [(cfg "mongo_dbname")] [(cfg "mongo_collection")]))

(def task (. *celery* task))
;(def href-re (.compile re "href=['\"](.+)['\"]"))
(def href-re "href=['\"](.+?)['\"]")
(def head-re (.compile re "<head>.*</head>"))
(def tag-re (.compile re "<.*?>"))

(defn now [] (-> (.utcnow datetime)
                 (.timestamp)))

(defn report-done! [url]
  (print "Reporting" url "done")
  (.hset *redis* "urls_last_checked" url (str (now))))

(defn content-care? [response]
  ;; Checks response to see if it is a content type we care about.
  (.startswith (. response headers ["Content-Type"]) "text"))

(defn response-care? [response]
  ;; Checks to see if response:
  ;; * was 200
  ;; * is some kind of text
  (and (= 200 (. response status_code))
       (content-care? response)))

(defn to-absolute [scheme netloc href]
  ;; Uses urlparse to figure out which parts of the href are missing
  ;; and re-uses scheme/netloc as appropriate.
  (let [[parsed (urlparse href)]]
    (->> href
         (+ (if (. parsed netloc) "" netloc))
         (+ (if (. parsed scheme) "" scheme)))))

(defn content= [response content]
  (.startswith (. response headers ["Content-Type"]) content))

(defn find-urls [url response]
  ;; Use whatever method makes the most sense for scraping URLs from
  ;; the page. Ensure that each one is absolute on the way out.
  ;; Note: returns generator
  (if (not (or (content= response "text/html")
               (content= response "text/xml")))
    []
    (let [[parsed (urlparse url)]
          [netloc (. parsed netloc)]
          [scheme (. parsed scheme)]
          [hrefs  (.findall re href-re (. response text) (. re S))]]
      (map (partial to-absolute scheme netloc) hrefs))))


(defn delete-head [html] (.sub re head-re "" html))

(defn delete-tags [html] (.sub re tag-re " " html))

(defn extract-text-from-html [html]
  (-> html delete-head delete-tags))

(defn to-text [response]
  ;; want to extract all prose. Most of the time things will be html,
  ;; but weirdness might happen if it is not. Perhaps just check to
  ;; see if it is plain text and take it wholesale; otherwise, assume
  ;; html
  (let [[text (. response text)]]
    (if (content= response "text/plain") ;; if not, we hope for html/xml
      text
      (extract-text-from-html text))))

(defn text-care? [text]
  ;; Checks to see if text seems to be english
  ;; Will likely use NLTK or an NLTK module
  ;; TODO
  true)

(defn streaming-get [url]
  (apply .get [requests url] {"stream" True}))

(with-decorator task
  (defn process [url]
    (with [[resp (closing (streaming-get url))]]
          (if (not (response-care? resp))
            (report-done! url)
            (let [[urls (find-urls url resp)]
                  [text (to-text resp)]]

              (print "Care about" url)
              (print "Found text:" (slice text 0 80))

              (for [u urls]
                (print (+ "found url" u))
                (.publish *redis* "urlfrontier" u))

              (when (text-care? text)
                (print (process-txt! text url *db*)))

              (report-done! url))))))
