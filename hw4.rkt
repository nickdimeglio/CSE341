
#lang racket

(provide (all-defined-out))
(require rackunit)

; 1
(define (sequence low high stride)
  (if (= low high)
      (cons low null)
      (cons low (sequence (+ low stride) high stride))))

; 2
(define (string-append-map xs suffix) (map (lambda (x) (string-append x suffix)) xs))

; 3
(define (list-nth-mod xs n)
(cond [(negative? n) (error "list-nth-mod: negative number")]
      [(null? xs) (error "list-nth-mod: empty list")]
      [#t (list-ref xs (remainder n (length xs)))]))

; 4
(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (cons (car (s))
            (stream-for-n-steps (cdr (s)) (- n 1)))))

; 5
(define (funny-number-stream)
  (letrec ([next (lambda (x) (if (= 0 (remainder x 5))
                          (cons (* -1 x) (lambda () (next (+ x 1))))
                          (cons x (lambda () (next (+ x 1))))))])
    (next 1)))

; 6
(define (dan-then-dog)
  (cons "dan.jpg"
        (lambda () (cons "dog.jpg"
                         (lambda () (dan-then-dog))))))

; 7
(define (stream-add-zero s)
  (lambda () (cons (cons 0 (car (s)))
                   (stream-add-zero (cdr (s))))))


; 8
(define (cycle-lists xs ys)
  (lambda () (cons (cons (car xs) (car ys))
                   (cycle-lists
                    (append (cdr xs) (list (car xs)))
                    (append (cdr ys) (list (car ys)))))))
  
; 9
(define (vector-assoc v vec)
  (letrec ([check (lambda (i)
                    (if (= i (vector-length vec))
                        #f
                        (if (pair? (vector-ref vec i))
                            (if (equal? v (car (vector-ref vec i)))
                                (vector-ref vec i)
                                (check (+ i 1)))
                            (check (+ i 1)))))])

    (check 0)))
                  
                      
      ; Cached assoc creates empty cache (all #f)
      ; Use a variable to track which cache slot will be replaced next
; 10
(define (cached-assoc xs n)
  (letrec ([cache (make-vector n #f)]
           [A 0])
    (lambda (v) (let ([check-cache (vector-assoc v cache)])
                  (if check-cache
                      check-cache
                      (if (assoc v xs)
                          (begin (vector-set! cache A (assoc v xs))
                           (set! A (if (= A (- n 1)) 0 (+ A 1))))
                          #f))))))
  

; 11
