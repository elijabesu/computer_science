;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SEMAPHORE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defclass semaphore (picture)
  ((light-count :initform 3)
   (semaphore-phase :initform 1)
   (background :initform (make-instance 'polygon))
   (bg-border :initform (make-instance 'polygon))
   (stop-light :initform (make-instance 'circle))
   (warn-light :initform (make-instance 'circle))
   (go-light :initform (make-instance 'circle))
   (stop-colour-on :initform :red)
   (stop-colour-off :initform :red4)
   (warn-colour-on :initform :orange)
   (warn-colour-off :initform :orange4)
   (go-colour-on :initform :green)
   (go-colour-off :initform :darkgreen)
   (bg-colour :initform :lightsteelblue4)
   (bg-border-colour :initform :grey30)))

(defmethod semaphore-phase ((s semaphore))
  (slot-value s 'semaphore-phase))

(defmethod set-semaphore-phase ((s semaphore) value)
  (unless (or (= value 1) (= value 2) (= value 3) (= value 4))
    (error "Variable semaphore-phase can only be a number between 1 and 4."))
  (setf (slot-value s 'semaphore-phase) value)
  (ensure-colour s)
  s)

(defmethod light-count ((s semaphore))
  (slot-value s 'light-count))

(defmethod set-light-count ((s semaphore) value)
  (unless (or (= value 2) (= value 3))
    (error "Variable light-count can only be a number 2 or 3."))
  (setf (slot-value s 'light-count) value)
  (if (= value 2)
      (set-items s (list
                    (slot-value s 'stop-light)
                    (slot-value s 'go-light)
                    (slot-value s 'background)
                    (slot-value s 'bg-border)))
      (set-items s (list
                    (slot-value s 'stop-light)
                    (slot-value s 'warn-light)
                    (slot-value s 'go-light)
                    (slot-value s 'background)
                    (slot-value s 'bg-border))))
  (create-semaphore s)
  (set-semaphore-phase s 1)
  s)

(defmethod create-semaphore ((s semaphore))
  (let ((bg (slot-value s 'background))
        (bg_b (slot-value s 'bg-border))
        (s_l (slot-value s 'stop-light))
        (g_l (slot-value s 'go-light)))
    (set-filledp (set-color bg (slot-value s 'bg-colour)) t)
    (set-filledp (set-color bg_b (slot-value s 'bg-border-colour)) t)
    (move (set-filledp (set-radius s_l 30) t) 80 60)
    (set-filledp (set-radius g_l 30) t)
    (cond ((= (light-count s) 2)
              (move g_l 80 125)
              (set-items bg_b (list
                              (move (make-instance 'point) 35 15)
                              (move (make-instance 'point) 35 175)
                              (move (make-instance 'point) 125 175)
                              (move (make-instance 'point) 125 15)))
              (set-items bg (list
                              (move (make-instance 'point) 40 20)
                              (move (make-instance 'point) 40 170)
                              (move (make-instance 'point) 120 170)
                              (move (make-instance 'point) 120 20))))
          ((= (light-count s) 3)
              (let ((w_l (slot-value s 'warn-light)))
                (move (set-radius (set-filledp w_l t) 30) 80 125)
                (move g_l 80 190)
                (set-items bg_b (list
                                (move (make-instance 'point) 35 15)
                                (move (make-instance 'point) 35 235)
                                (move (make-instance 'point) 125 235)
                                (move (make-instance 'point) 125 15)))
                (set-items bg (list
                                (move (make-instance 'point) 40 20)
                                (move (make-instance 'point) 40 230)
                                (move (make-instance 'point) 120 230)
                                (move (make-instance 'point) 120 20)))))))
  s)

(defmethod ensure-colour ((s semaphore))
  (let ((sem_pha (semaphore-phase s)))
    (cond ((= (light-count s) 3)
           (set-color (slot-value s 'stop-light)
                      (slot-value s (if (or (= sem_pha 1) (= sem_pha 2))
                                        'stop-colour-on
                                      'stop-colour-off)))
           (set-color (slot-value s 'warn-light)
                      (slot-value s (if (or (= sem_pha 2) (= sem_pha 4))
                                        'warn-colour-on
                                      'warn-colour-off)))
           (set-color (slot-value s 'go-light)
                      (slot-value s (if (= sem_pha 3)
                                        'go-colour-on
                                      'go-colour-off))))
          ((= (light-count s) 2)
           (set-color (slot-value s 'stop-light)
                      (slot-value s (if (= sem_pha 1)
                                        'stop-colour-on
                                      'stop-colour-off)))
           (set-color (slot-value s 'go-light)
                      (slot-value s (if (= sem_pha 3)
                                        'go-colour-on
                                      'go-colour-off))))))
  s)

(defmethod next-phase ((s semaphore))
  (if (= (light-count s) 2)
      (if (= (semaphore-phase s) 1)
          (set-semaphore-phase s 3)
        (set-semaphore-phase s 1))
    (if (= (semaphore-phase s) 4)
        (set-semaphore-phase s 1)
      (set-semaphore-phase s (+ (semaphore-phase s) 1))))
  s)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CROSSROAD ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defclass crossroad (picture)
  ((road :initform (make-instance 'polygon))
   (sidewalk :initform (make-instance 'polygon))
   (zebra :initform (make-instance 'picture))
   (semaphore-phase :initform 1)
   (semaphores :initform (make-instance 'picture))
   (main-road-semaphores :initform nil)
   (side-road-semaphores :initform nil)
   (main-walk-semaphores :initform nil)
   (side-walk-semaphores :initform nil)))

(defmethod semaphore-phase ((c crossroad))
  (slot-value c 'semaphore-phase))

(defmethod set-semaphore-phase ((c crossroad) value)
  (unless (or (= value 1) (= value 2) (= value 3) (= value 4))
    (error "Variable semaphore-phase can only be a number between 1 and 4."))
  (setf (slot-value c 'semaphore-phase) value)
  (let ((mr_sems (slot-value c 'main-road-semaphores))
        (sr_sems (slot-value c 'side-road-semaphores))
        (mw_sems (slot-value c 'main-walk-semaphores))
        (sw_sems (slot-value c 'side-walk-semaphores)))
    (cond ((= value 1)
           (dolist (s mr_sems)
             (set-semaphore-phase s 1))
           (dolist (s sr_sems)
             (set-semaphore-phase s 3))
           (dolist (s mw_sems)
             (set-semaphore-phase s 3))
           (dolist (s sw_sems)
             (set-semaphore-phase s 1)))
          ((= value 2)
           (dolist (s mr_sems)
             (set-semaphore-phase s 2))
           (dolist (s sr_sems)
             (set-semaphore-phase s 4))
           (dolist (s mw_sems)
             (set-semaphore-phase s 1))
           (dolist (s sw_sems)
             (set-semaphore-phase s 1)))
          ((= value 3)
           (dolist (s mr_sems)
             (set-semaphore-phase s 3))
           (dolist (s sr_sems)
             (set-semaphore-phase s 1))
           (dolist (s mw_sems)
             (set-semaphore-phase s 1))
           (dolist (s sw_sems)
             (set-semaphore-phase s 3)))
          ((= value 4)
           (dolist (s mr_sems)
             (set-semaphore-phase s 4))
           (dolist (s sr_sems)
             (set-semaphore-phase s 2))
           (dolist (s mw_sems)
             (set-semaphore-phase s 1))
           (dolist (s sw_sems)
             (set-semaphore-phase s 1)))))
  c)

(defmethod create-empty-semaphores ((c crossroad))
  (setf (slot-value c 'main-road-semaphores) (list ;; zacinaji jako off
                 (set-light-count (make-instance 'semaphore) 3)
                 (set-light-count (make-instance 'semaphore) 3)))
  (setf (slot-value c 'side-road-semaphores) (list ;; zacinaji jako on
                 (set-semaphore-phase (set-light-count (make-instance 'semaphore) 3) 3)
                 (set-semaphore-phase (set-light-count (make-instance 'semaphore) 3) 3)))
  (setf (slot-value c 'main-walk-semaphores) (list ;; zacinaji jako on
                 (set-semaphore-phase (set-light-count (make-instance 'semaphore) 2) 3)
                 (set-semaphore-phase (set-light-count (make-instance 'semaphore) 2) 3)
                 (set-semaphore-phase (set-light-count (make-instance 'semaphore) 2) 3)
                 (set-semaphore-phase (set-light-count (make-instance 'semaphore) 2) 3)))
  (setf (slot-value c 'side-walk-semaphores) (list ;; zacinaji jako off
                 (set-light-count (make-instance 'semaphore) 2)
                 (set-light-count (make-instance 'semaphore) 2)
                 (set-light-count (make-instance 'semaphore) 2)
                 (set-light-count (make-instance 'semaphore) 2)))
  c)

(defmethod create-semaphores ((c crossroad))
  (create-empty-semaphores c)
  (let ((sems (slot-value c 'semaphores))
        (mr_sems (slot-value c 'main-road-semaphores))
        (sr_sems (slot-value c 'side-road-semaphores))
        (mw_sems (slot-value c 'main-walk-semaphores))
        (sw_sems (slot-value c 'side-walk-semaphores))
        (center (move (make-instance 'point) 400 400)))
  (dolist (s mr_sems)
    (scale s 0.4 center))
  (move (rotate (first mr_sems) pi center) -205 -320) ; top
  (move (second mr_sems) 205 320) ; bottom
  (dolist (s sr_sems)
    (scale s 0.4 center))
  (move (rotate (first sr_sems) (/ pi 2) center) -320 205) ; left
  (move (rotate (second sr_sems) (* pi 1.5) center) 320 -205) ; right
  (dolist (s mw_sems)
    (scale s 0.3 center))
  (move (rotate (first mw_sems) (/ pi 2) center) 35 -70) ; top right
  (move (rotate (second mw_sems) (/ pi 2) center) 35 260) ; bottom right
  (move (rotate (third mw_sems) (* pi 1.5) center) -35 -260); top left
  (move (rotate (fourth mw_sems) (* pi 1.5) center) -35 70) ; bottom left
  (dolist (s sw_sems)
    (scale s 0.3 center))
  (move (first sw_sems) 260 -35) ; top right
  (move (rotate (second sw_sems) pi center) 70 35) ; bottom right
  (move (third sw_sems) -70 -35) ; top left
  (move (rotate (fourth sw_sems) pi center) -260 35) ; bottom left
  (set-items sems (append mr_sems sr_sems mw_sems sw_sems)))
  c)

(defmethod create-background ((c crossroad))
  (let ((walk (slot-value c 'sidewalk))
        (road (slot-value c 'road)))
    (set-items walk (list (move (make-instance 'point) 0 240)     ;1
                          (move (make-instance 'point) 0 560)     ;2
                          (move (make-instance 'point) 240 560)   ;3
                          (move (make-instance 'point) 240 800)   ;4
                          (move (make-instance 'point) 560 800)   ;5
                          (move (make-instance 'point) 560 560)   ;6
                          (move (make-instance 'point) 800 560)   ;7
                          (move (make-instance 'point) 800 240)   ;8
                          (move (make-instance 'point) 560 240)   ;9
                          (move (make-instance 'point) 560 0)     ;10
                          (move (make-instance 'point) 240 0)     ;11
                          (move (make-instance 'point) 240 240))) ;12
    (set-color (set-filledp walk t) :snow3)
    (set-items road (list (move (make-instance 'point) 0 300)     ;1
                          (move (make-instance 'point) 0 500)     ;2
                          (move (make-instance 'point) 300 500)   ;3
                          (move (make-instance 'point) 300 800)   ;4
                          (move (make-instance 'point) 500 800)   ;5
                          (move (make-instance 'point) 500 500)   ;6
                          (move (make-instance 'point) 800 500)   ;7
                          (move (make-instance 'point) 800 300)   ;8
                          (move (make-instance 'point) 500 300)   ;9
                          (move (make-instance 'point) 500 0)     ;10
                          (move (make-instance 'point) 300 0)     ;11
                          (move (make-instance 'point) 300 300))) ;12
    (set-color (set-filledp road t) :grey50))
  c)

(defmethod create-one-zebra ((c crossroad))
  (let ((fi_z (make-instance 'polygon))
        (se_z (make-instance 'polygon))
        (th_z (make-instance 'polygon))
        (zebra (make-instance 'picture)))
    (set-items fi_z (list (move (make-instance 'point) 240 320)
                         (move (make-instance 'point) 240 360)
                         (move (make-instance 'point) 300 360)
                         (move (make-instance 'point) 300 320)))
    (set-color (set-filledp fi_z t) :snow)
    (set-items se_z (list (move (make-instance 'point) 240 380)
                         (move (make-instance 'point) 240 420)
                         (move (make-instance 'point) 300 420)
                         (move (make-instance 'point) 300 380)))
    (set-color (set-filledp se_z t) :snow)
    (set-items th_z (list (move (make-instance 'point) 240 440)
                          (move (make-instance 'point) 240 480)
                          (move (make-instance 'point) 300 480)
                          (move (make-instance 'point) 300 440)))
    (set-color (set-filledp th_z t) :snow)
    (set-items zebra (list fi_z se_z th_z))))

(defmethod create-zebras ((c crossroad))
  (let ((fi_z (create-one-zebra c))
        (se_z (rotate (create-one-zebra c) (/ pi 2) (move (make-instance 'point) 400 400)))
        (th_z (move (create-one-zebra c) 260 0))
        (fo_z (rotate (create-one-zebra c) (* pi 1.5) (move (make-instance 'point) 400 400)))
        (zebra (slot-value c 'zebra)))
    (set-items zebra (list fi_z se_z th_z fo_z))))

(defmethod next-phase ((c crossroad))
  (if (= (semaphore-phase c) 4)
      (set-semaphore-phase c 1)
    (set-semaphore-phase c (+ (semaphore-phase c) 1)))
  c)

(defmethod initialize-instance ((c crossroad) &key)
  (call-next-method)
  (create-background c)
  (create-zebras c)
  (create-semaphores c)
  (set-items c (list (slot-value c 'semaphores)
                     (slot-value c 'zebra)
                     (slot-value c 'road)
                     (slot-value c 'sidewalk)))
  c)

(defun display-crossroad (c)
  (let ((w (make-instance 'window)))
    (mg:set-size (mg-window w) 800 800)
    (sleep 0.25)
    (set-background w :olivedrab)
    (set-shape w c)
    (redraw w)))

(defun create-crossroad ()
  (make-instance 'crossroad))
  
;; VYHODNOCOVAT POSTUPNE
;    (setf c (create-crossroad))
;    (setf w (display-crossroad c))
;    (next-phase c)
;    (redraw w)
