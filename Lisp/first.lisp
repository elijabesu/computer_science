;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GAME ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defclass game ()
  ((health :initform nil)
   (level :initform nil)))

(defmethod health ((game game))
  (slot-value game 'health))

(defmethod set-health ((game game) value)
  (unless (typep value 'number)
    (error "Variable health must be a number."))
  (setf (slot-value game 'health) value))

(defmethod level ((game game))
  (slot-value game 'level))

(defmethod set-level ((game game) value)
  (unless (typep value 'number)
    (error "Variable level must be a number."))
  (setf (slot-value game 'level) value))

(defvar *game* (make-instance 'game))

(defvar *options*
  (list
   "Stojite v arene s jednim dalsim protivnikem, ktery ma stejne moznosti jako vy. Mate ~D zivoty. ~A~%~%1. Rozbehnete se na pravou stranu pro nuz.~%2. Rozbehnete se proti nemu.~%~%~A~%" ; 0
   (list
    "~A ~A Mate ~D zivoty. ~A~%~%1. Zvednete se a popadnete nuz.~%2. Rozbehnete se a zkusite ziskat nejaky naskok.~%~%~A~%" ; 1
    "Protivnik se priblizil dostatecne a nozem vas rizl do ramene vasi dominantni ruky. ~A Mate ~D zivot. ~A~%~%1. Zvednete nuz v druhe ruce a bodnete ho. ~%2. Vzdalite se a chytnete si ranu, abyste neztratili moc krve.~%~%~A~%" ; 11
    "Rychle ztracite krev. Zacne se vam tocit hlava a vy se zhroutite k zemi. Nevstavate dostatecne dlouho, abyste byly prohlaseni porazenymi...~%~%KONEC HRY"; 112 ----- KONEC HRY
    )
   (list
    "~A ~A Mate ~D zivoty. ~A~%~%1. Zvednete se a priblizite se k nemu, nasledne jej kopnete.~%2. Rozbehnete se a zkusite ziskat nejaky naskok.~%~%~A~%" ; 2
    "Kopli jste ho do citliveho mista, protivnik se zhroutil k zemi v bolestnych krecich. Nevstava dostatecne dlouho, abyste byli prohlaseni vitezem. Gratuluji!~%~%KONEC HRY" ; 21 ----- KONEC HRY
    )
   (list
    "Zakopnete o kamen, ktery vam lezel v ceste. Protivnik mezi tim ziskal nuz a rychle se blizi k vam." ; zacatek 1 a 2
    "Vas protivnik je velmi pomaly a vy jste ziskali dostatecny naskok. Mate ~D zivoty. ~A~%~%1. Popadnete nuz a pobezite k nemu, nasledne protivnika bodnete.~%2. Pokracujete v behu dokud se neunavi.~%~%~A~%" ; 12 a 22
    "Bodli jste ho do citliveho mista, protivnik se zhroutil k zemi v bolestnych krecich. Nevstava dostatecne dlouho, abyste byli prohlaseni vitezem. Gratuluji!~%~%KONEC HRY"; 121 a 221 a 111 ----- KONEC HRY
    "Po nejake chvili se protivnik unavi a zastavi. Mate ~D zivoty. ~A~%~%1. Priblizite se k nemu a kopnete ho.~%2. Cekate dokud zcela nepolozi svuj nuz.~%~%~A~%"; 122 a 222
    "Kdyz jste se priblizili, zvedl se a nasledne vas rizl. ~A Mate ~D zivoty. ~A~%~%1. Zacnete znovu utikat.~%2. Rychle ho kopnete znovu." ; 1221 a 2221
    "Po dalsi chvili polozi svuj nuz a lehne si ve vycerpani. Nevstava dostatecne dlouho, abyste byli prohlaseni vitezem. Gratuluji!~%~%KONEC HRY" ; 1222 a 2222 ----- KONEC HRY
    "Protivnik zacne za vami utikat, ale po kratke chvili se unavi dostatecne na to, aby si lehl. Nevstava dostatecne dlouho, abyste byli prohlaseni vitezem. Gratuluji!~%~%KONEC HRY"; 12211 A 2221  ----- KONEC HRY
    )
   "Ztratili jste 1 zivot."
   "Co udelate?"
   "Vyberte moznost X pouzitim (choose X)."))

(defmethod next_step ((game game) option)
  (unless (or (typep option 'number) (= option 1) (= option 2))
    (error "Option can only be 1 or 2."))
  (let ((lvl (level game))
        (hlth (health game))
        (opt_1 (second *options*))
        (opt_2 (third *options*))
        (opt_obe (fourth *options*))
        (minus (fifth *options*))
        (co_dal (sixth *options*))
        (vyber (seventh *options*)))
    (cond ((= lvl 0) (set-health game (- hlth 1))
                     (cond
                      ((= option 1) (format t (first opt_1) (first opt_obe) minus (health game) co_dal vyber))
                      ((= option 2) (format t (first opt_2) (first opt_obe) minus (health game) co_dal vyber))))
          ((= lvl 1) (cond
                      ((= option 1) (set-health game (- hlth 1))
                       (format t (second opt_1) minus (health game) co_dal vyber))
                      ((= option 2) (format t (second opt_obe) hlth co_dal vyber))))
          ((= lvl 11) (cond
                       ((= option 1) (format t (third opt_obe))) ;; KONEC HRY ---- 111
                       ((= option 2) (format t (third opt_1))) ;; KONEC HRY ---- 112
          ((= lvl 2) (cond
                      ((= option 1) (format t (second opt_2))) ;; KONEC HRY ---- 21
                      ((= option 2) (format t (second opt_obe) hlth co_dal vyber))))
          ((or (= lvl 12) (= lvl 22)) (cond
                                       ((= option 1) (format t (third opt_obe))) ;; KONEC HRY ---- 121 a 221
                                       ((= option 2) (format t (fourth opt_obe) hlth co_dal vyber))))
          ((or (= lvl 122) (= lvl 222)) (cond
                                         ((= option 1) (set-health game (- hlth 1))
                                                       (format t (fifth opt_obe) minus (health game) co_dal vyber))
                                         ((= option 2) (format t (sixth opt_obe))))) ;; KONEC HRY ---- 1222 a 2222
          ((or (= lvl 1221) (= lvl 2221)) (cond
                                           ((= option 1) (format t (seventh opt_obe))))) ;; KONEC HRY ---- 12211 a 22211
                                           ((= option 2) (format t (second opt_2))))) ;; KONEC HRY ---- 12212 a 22212 == 21
    )
    (set-level game (+ (* lvl 10) option)))
)

(defun start ()
  (set-health *game* 3)
  (set-level *game* 0)
  (format t (first *options*) (health *game*) (sixth *options*) (seventh *options*)))

(defun choose (option)
  (next_step *game* option)
  nil)
