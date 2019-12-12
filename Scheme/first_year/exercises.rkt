; ukol 1: pyramid
(define (pyramid d v)
  (define (a? d) ; zjisteni a
    (* (/ (sqrt 2) 2) d))
  (* (a? d) (+ (a? d) (sqrt (+ (* 4 v v) (* (a? d) (a? d)))))))

; ukol 2: my-positive?
(define (my-positive? x) (> x 0))

; ukol 3: roots
(define (roots a b c)
  (define x1 (koren1 a b c))
  (define x2 (koren2 a b c))
  (cond ((and (integer? x1)
             (integer? x2))
         (cons x1 x2))
        (else #f)))

(define (diskriminant a b c)
  (- (* b b) (* 4 a c)))
(define (koren1 a b c)
  (/ (+ (- b) (sqrt (diskriminant a b c))) (* 2 a)))
(define (koren2 a b c)
  (/ (- (- b) (sqrt (diskriminant a b c))) (* 2 a)))

; ukol 4: weighted-sum

; ukol 5: my-cons, my-car, my-cdr, switch
(define my-cons
  (lambda (x y)
    (lambda (z)
      (if z x y))))

(define (my-car x) (x #t))
(define (my-cdr x) (x #f))

(define (switch z) (my-cons (z #f) (z #t)))

; ukol 6: make-palindrom
(define (make-palindrom x)
  (define y (otocit_list x))
  (pridat_otoceny x y))
          
(define (otocit_list x)
  (define delka (length x))
  (if (odd? delka) (set! delka (- delka 1)))
  (build-list delka
              (lambda (i)
                (list-ref x (- delka i 1)))))

(define (pridat_otoceny x y)
  (define delka1 (length x))
  (define delka2 (length y))
  (build-list (+ delka1 delka2)
              (lambda (i)
                (if (< i delka1)
                    (list-ref x i)
                    (list-ref y (- i delka1))))))

; ukol 7: euclid
(define (euclid x y)
    (if (zero? y) x
        (euclid y (remainder x y))))

; ukol 8: von-neumann

; ukol 9: rle-coding

; ukol 10: histogram

