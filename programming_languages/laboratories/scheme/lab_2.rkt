#lang racket
;; Bruno Maglioni A01700879

;; functions from racket: length.

;; Extra functions:
;; check if a symbol exist in a list.
(define (contains? a-symbol a-list)
  (cond
    [(empty? a-list) false]
    [else (or (= a-symbol (first a-list))
              (contains? a-symbol (rest a-list)))]))

;; builds a list in reverse order.
(define (reverse lst acc)
  (cond
    [(empty? lst) acc]
    [else (reverse (rest lst) (cons (first lst) acc))]))

;; returns the negative of a positive number.
(define (negative num)
  (- num (* num 2)))

;; ----------------------------------------------------

;; power-head: number number -> number
;; returns the power of n^p using head recursion
;; (power-head 4 3) = 64
(define (power-head n p)
  (if (<= p 1)
      n
      (* n (power-head n (- p 1)))))

;; power-tail: number number number -> number
;; returns the power of n^p using tail recursion
;; (power-tail 4 3) = 64
(define (power-tail n p)
  (let power-tail-h [(p p) (result 1)]
    (if (< p 1)
        result
        (power-tail-h (- p 1) (* result n)))))

;; third: list -> element
;; returns the third element of a list
;; (third (cons 1(cons 2 (cons 3 (cons 4 (cons 5 empty)))))) = 3
(define (third lst)
  (cond
    [(empty? lst) empty]
    [(< (length lst) 3) empty]
    [else (first (rest (rest lst)))]))

;; just-two?: list -> boolean
;; returns true if a list has only 2 elements.
;; (just-two? (cons 1 (cons 4 empty))) = true
(define (just-two? lst)
  (cond
    [(empty? lst) false]
    [(= (length lst) 2) true]
    [else false]))

;; how-many-x?: list element -> number
;; returns the number of elements that match x in a list.
;; (define list (cons 1(cons 2 (cons 3 (cons 4 (cons 3 empty))))))
;; (how-many-x? list 3) = 2
(define (how-many-x? lst x)
  (cond
    [(empty? lst) 0]
    [else (cond
            [(eq? (first lst) x) (+ 1 (how-many-x? (rest lst) x))]
            [else (how-many-x? (rest lst) x)])]))

;; all-x?: list element -> boolean
;; returns true if all elements of a list match x.
;; (define list (cons 3(cons 3 (cons 3 (cons 3 (cons 3 empty))))))
;; (all-x? list 3) = true
(define (all-x? lst x)
  (cond
    [(empty? lst) false]
    [else (cond
            [(= (length lst) 1) (cond
                                  [(eq? (first lst) x) true]
                                  [else false])]
            [(eq? (first lst) x) (all-x? (rest lst) x)]
            [else false])]))

;; get: list pos -> element
;; returns the element in the position pos of a list.
;; (define list (cons 1(cons 2 (cons 3 (cons 4 (cons 3 empty))))))
;; (get list 2) = 2
(define (get lst pos)
  (cond
    [(empty? lst) empty]
    [(eq? pos 1) (first lst)]
    [else (get (rest lst) (- pos 1))]))

;; diference: list list -> list
;; returns a new list that has the elements of the first one
;; that aren't on the second one.
;; (difference '(12 44 55 77 66 1 2 3 4) '(1 2 3)) =  '(4 66 77 55 44 12)
(define (difference lst-a lst-b)
  (cond
    [(empty? lst-a) empty]
    [(empty? lst-b) lst-a]
    [else (if (contains? (first lst-a) lst-b)
              (difference (rest lst-a) lst-b)
              (cons (first lst-a) (difference (rest lst-a) lst-b)))]))


;; append: list list -> list
;; returns a new list with the elements of both lists received (first list A, then list B).
;; (append '(a b c d) '(e f g)) = (a b c d e f g)
(define (append lst-a lst-b)
  (cond
    [(empty? lst-a) lst-b]
    [(empty? lst-b) lst-a]
    [else (cons (first lst-a) (append (rest lst-a) lst-b))]))

;; invert: lst -> lst
;; returns the same list, but with the elements in reverse order.
;; (invert '(a b c d)) = (d c b a)
(define (invert lst)
  (cond
    [(empty? lst) empty]
    [else (reverse lst '())]))

;; sign: alon -> alon
;; returns a list made of 1 or -1, depending on whether each number
;; of the list received is greater or lesser than 0.
;; (sign '(2 -4 -6)) = (1 -1 -1)
(define (sign alon)
  (cond
    [(empty? alon) empty]
    [else (cond
            [(< (first alon) 0) (cons -1 (sign (rest alon)))]
            [else (cons 1 (sign (rest alon)))])]))

;; negatives: alon -> alon
;; returns a list with the corresponding negative numbers of the
;; list received.
;; (negatives '(2 4 6)) = (-2 -4 -6)
(define (negatives alon)
  (cond
    [(empty? alon) empty]
    [else (cons (negative (first alon)) (negatives (rest alon)))]))
