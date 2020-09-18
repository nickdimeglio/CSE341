#lang Racket

; Section B Week 1 Notes


(define start null);

(define next (cons 64 start));

(define sixtyfour 64);


(define (sum xs)
  (if (null? xs)
      0
      (+ (car xs) (sum (cdr xs)))))

(define (double1 x)
  (let ([x (+ x 2)]  
        [y (+ x 3)])  ; refers to top-level x
    (+ x y -5)))

(define (double2 x)
  (let* ([x (+ x 2)]
         [y (+ x 3)]) ; refers to x in previous let-expression
    (+ x y -7)))

(define (triple x)
  (letrec ([y (+ x 0)]
           [z (lambda(z) (+ z x y q 30))]   ; define a function using w before defining w
           [q (+ x 10 -10)])                ; w will be defines when function is called
    (z -30)))


; Defining a stream
; Returns 1 1 1 1 1 ...

(define ones (lambda () (cons 1 ones)))

; Returns 1 2 3 4 5 ...

; (define (f x) (cons x (lambda () (f (+ x 1)))))
; (define nats (lambda () (f 1)))


(define nats
  (letrec ([f (lambda (x) (cons x (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))





