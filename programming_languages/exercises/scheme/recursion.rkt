#lang racket
;; head recursion
(define (add_all x)
  (cond
    [(< x 1) 0] ;; base case
    [else (+ (add_all (- x 1)) x)]))

;; tail recursion
(define (add_all_t x y)
  (cond
    [(< x 1 y)] ;; base case
    [else (add_all_t (- x 1) (+ x y))]))

;; list from 0 to x
(define (el lista x)
  (cond
    [(< x 1) lista]
    [else (el (cons x lista) (- x 1))]))

;; list from x to 0
(define (el_up lista x z)
  (cond
    [(< x 1) lista]
    [else (el_up (cons z lista) (- x 1) (+ z 1))]))