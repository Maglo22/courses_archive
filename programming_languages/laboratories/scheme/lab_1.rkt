#lang racket
;; Bruno Maglioni A01700879 - Lab 1


;; triangle-area: number number -> number
;; returns de area of the triangle with base b
;; and height h.
;; ex: (triangle-area 3 4) = 6
(define (triangle-area b h)
  (/ (* b h) 2))

;; a: number -> number
;; returns the result of calculating n² + 10
;; ex: (a 2) = 14
(define (a n)
  (+ (expt n 2) 10))

;; b: number -> number
;; returns the result of calculating (1/2 * n²) + 20
;; ex: (b 2) = 22
(define (b n)
  (+ (* (expt n 2) .5) 20))

;; c: number -> number
;; returns the result of calculating 2 - (1/n)
;; ex: (c 2) = 1.5
(define (c n)
  (- 2 (/ 1 n)))

;; solutions: number number number -> number
;; returns the number of possible solutions of a
;; quadratic equiation (ax² + bx + c) based on
;; the values of a, b and c.
;; ex: (solutions 2 4 2) = 1
(define (solutions a b c)
  (cond
    [(> (expt b 2) (* 4 a c)) 2]
    [(= (expt b 2) (* 4 a c)) 1]
    [(< (expt b 2) (* 4 a c)) 0]))