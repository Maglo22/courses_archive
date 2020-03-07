#lang racket

;; check if the element is a leaf (doesn't have children).
(define (leaf? tree)
  (cond
    [(empty? (cdr tree)) true]
    [else false]))

;; return the children of the element.
(define (children tree)
  (cdr tree))

;; counts the values of the leaves in a tree. Add the value of
;; the parent as well.
(define (count-nodes tree)
  (if (leaf? tree)
      (first tree)
      (+ (count-nodes-in-forest (children tree))(first tree))))

;; mutual recursion.
(define (count-nodes-in-forest forest)
  (if (null? forest)
      0
      (+ (count-nodes (car forest))
         (count-nodes-in-forest (cdr forest)))))