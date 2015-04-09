(defn hack-nltk-data-path! []
  ;; TODO will nltk search *all* of these paths for things, or just
  ;; take the first match and use that?
  (setv (. nltk data path) (+ (. nltk data path)
                              (->> (. sys path)
                                   (map (fn [p] (.format "{}/scamall/nltk_data" p)))
                                   list))))
(import [functools [lru-cache]])
(import sys)

(import nltk)
(hack-nltk-data-path!)
(import [nltk.corpus [stopwords]])
(import [nltk [wordpunct-tokenize]])

;; computes possible language by checking how many stopwords from each
;; language occur in source text and ranking them.

;; a possible optimization is to chunk the input text into substrings
;; of length N and compute the "winner" for each substring, computing
;; a frequency dist, and taking the ultimate winner from that. that
;; way, common substrings can be memoized across different inputs.

(def english-key "english")

(defn tokenize->set [text]
  (->> text
       wordpunct-tokenize
       (map (fn [w] (.lower w)))
       set))

(with-decorator (lru-cache 100)
  (defn set-for-stopwords [lang]
    (-> (.words stopwords lang)
        set)))

(defn stopword-score [lang words-set]
  (-> (.intersection words-set (set-for-stopwords lang))
      len))

(defn compute-stopword-scores [text]
  (let [[words-set (tokenize->set text)]]
    (->> (.fileids stopwords)
         (map (fn [lang]
                (, lang (stopword-score lang words-set))))
         dict)))

(defn english? [text]
  (let [[scores (compute-stopword-scores text)]
        [winner (apply max [scores] {"key" (. scores get)})]]
    (print (+ "language winner is " winner))
    (= english-key winner)))
