#lang racket

;; Bruno Maglioni A01700879

;; Functions from racket: append.

;; Helper functions
;; makes a new node (list)
(define (make-node val children)
  (cons val children))

;; returns children of a node.
(define (children node)
  (cdr node))

;; returns the value of a node.
(define (val node)
  (car node))

;; checks if the node is a leaf.
(define (leaf? node)
  (null? (children node)))

;; builds a list in reverse order.
(define (reverse lst acc)
  (cond
    [(empty? lst) acc]
[else (reverse (rest lst) (cons (first lst) acc))]))

;; returns lenght of a list.
(define (length lst)
   (cond ((null? lst)
          0)
         (else
          (+ 1 (length (cdr lst))))))

;;aux function for deep-x
(define (aux-deep-all-x? lst x)
(cond [(empty? lst) #t]
   [(equal? (val lst) x) (aux-deep-all-x? (rest lst) x)]
   [(list? (first lst)) (and (aux-deep-all-x? (first lst) x) (aux-deep-all-x? (rest lst) x))]
   [else #f]))

;; -------------------------------------------

;; deep-all-x?: list element -> boolean
;; returns true if all elements in the list of lists is x.
;; (deep-all-x? '(a (a (a a)) a (a a)) 'a) = true
(define (deep-all-x? dlst x)
(cond [(empty? dlst) #f]
[else (aux-deep-all-x? dlst x)]))


;; deep-reverse: deep-list -> deep-list
;; returns a new list of lists with the elements in reverse order.
;; (deep-reverse '(a (b (c d)) e (f g))) = ((g f) e ((d c) b) a)
(define (deep-reverse dlst)
  (if (list? dlst)
      (reverse (map deep-reverse dlst) '())
      dlst))


;; flatten: deep-list -> list
;; returns a new list with all the elements of the deep list in
;; the same level.
;; (flatten '(a (b (c d)) e (f g))) = (a b c d e f g)
(define (flatten lst)
  (cond
    [(empty? lst) empty]
    [(list? (first lst))
     (append (flatten (first lst)) (flatten (children lst)))]
    [else (make-node (val lst) (flatten (children lst)))]))


;; count-levels: tree -> number
;; returns the maximum depth of a tree.
;; (count-levels '(a (b (c d)) e (f g))) = 3
(define (count-levels tree)
  (cond
    [(empty? tree) 0]
    [(list? (first tree))
     (+ 1 (count-levels (first tree)) (count-levels (children tree)))]
    [else (count-levels (children tree))]))


;; count-max-arity: tree -> number
;; returns the maximum number of childreen a single node has.
;; (count-max-arity '(a (b (c) (d)) (e (f) (g) (h) (i)))) = 4
(define (count-max-arity tree)
  (cond
    [(empty? tree) 0]
    [else (if (list? tree)
              (length (map count-max-arity tree))
              tree)]))
