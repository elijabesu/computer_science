;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MAKE-MY-PICTURE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun make-my-picture ()
    (let ((cir (make-instance 'circle))
          (pic (make-instance 'picture))
          (pol (make-instance 'polygon))
          (main_picture (make-instance 'picture)))
      ;; circle
      (set-radius cir 15)
      (set-color cir :pink)
      (set-filledp cir t)
      (move cir 100 100)
      ;; polygon
      (set-items pol (list
                      (move (make-instance 'point) 75 160)
                      (move (make-instance 'point) 50 90)
                      (move (make-instance 'point) 100 25)
                      (move (make-instance 'point) 150 90)
                      (move (make-instance 'point) 125 160)))
      (set-filledp pol nil)
      (set-thickness pol 5)
      (set-color pol :darkslategrey)
      ;; picture
      (set-items pic (list
                      (move (set-radius (set-filledp (make-instance 'circle) t) 10) 100 15)
                      (move (set-thickness (set-color (make-instance 'point) :skyblue) 5) 40 90)
                      (move (set-thickness (set-color (make-instance 'point) :skyblue) 5) 160 90)))
      ;; main_picture
      (set-items main_picture (list cir pol pic))))
