#lang racket

;;simple
;;call: (av 23 34 66)
(define (av a b c)
  (/ (+ a b c) 3))


;;anonymous
;;call: ((lambda (a b c) (/ (+ a b c) 3)) 11 22 33)
(lambda (a b c) (/ (+ a b c) 3))


;;classic lambda
;;call: (((ave 44) 77) 80)
(define ave (lambda (a)
              (lambda (b)
                (lambda (c) (/ (+ a b c) 3)))))

;;operation recieves the procedure or function to apply
;;(lambda) and 3 values
(define (operation op a b c)
  (op a b c))

;;using anonymous functions
(operation (lambda (a b c) (/ (+ a b c) 3)) 23 34 66)