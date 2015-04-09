(import [redis [StrictRedis]])
(import [scamall.tasks [process]])

;; The high level job of this module is to subscribe to the
;; urlfrontier in redis and check the urls_last_checked hash for each
;; one. If it either isn't there or it's been greater than some number
;; of days since the url was checked, runs process.delay.

;; I think ... that is all?

;; Remaining big TODO is to implement text-care? somehow. Once that's
;; done I'll have something to test out on the phones.

;; I think I should work on text-care first since that's part of the
;; phone stack. I want the full celery task tested on at least one
;; phone before I start building the brain out.


;; Well, shit. It's time to test the full stack on a phone.

;; What I need for the first test:

;;  Nexus S with debian (somehow)

;; the scamall package, after installing manually prosaic (which is too big to put on pypi :( :( :( )

;; python-virtualenv, python-dev, python3.4, python-pip

;; don't need redis/mongo since it'll be talking to laptop
