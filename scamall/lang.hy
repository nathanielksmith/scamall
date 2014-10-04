(import [functools [lru-cache]])
(import [nltk.corpus [stopwords]])
(import [nltk [wordpunct-tokenize]])

;; does basic set intersection against english stop words. uses length
;; of intersection to compute ratio of english vs. non-english words.

;; a possible optimization is to chunk the input text into substrings
;; of length N and use an lru-cache wrapper around english?, summing
;; the ratios up at the end.

(def english-key "english")
(def english-threshold .45) ;; totally arbitrary percentage, will likely tweak

(defn tokenize->set [text]
  (->> text
       wordpunct-tokenize
       (map (fn [w] (.lower w)))
       set))

;; only ever called for english, so set maxsize to 1
(with-decorator (lru-cache 1)
  (defn set-for-stopwords [lang]
    (-> (.words stopwords lang)
        set)))

(defn english? [text]
  (let [[words (tokenize->set text)]
        [eng-stopwords-set (set-for-stopwords english-key)]
        [english-words (.intersection words eng-stopwords-set)]
        [ratio (/ (len english-words) (len (set words)))]]
    (> ratio english-threshold)))
