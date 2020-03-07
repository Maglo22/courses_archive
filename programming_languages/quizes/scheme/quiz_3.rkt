#lang racket

;; returns left subtree
(define (left-tree tree)
  (cond
    [(empty? tree) empty]
    [(empty? (cdr tree)) empty]
    [(car (cdr tree))]))

;; returns right subtree
(define (right-tree tree)
  (cond
    [(empty? tree) empty]
    [(empty? (cdr tree)) empty]
      (car (car (cdr (cdr tree))))))

;; bst-has?: tree number -> boolean
;; returns weather an element is present in a binary tree.
;; (define t'(8(5(2)(7))(11(9)(61))))
;; (bst-has? t 61) = true. (bst-has? t -100) = false.
(define (bst-has? tree value)
    (cond
      [(empty? tree) false]
      [(= (first tree) value) true]
      [else (cond
              [(> (car tree) value)
               (bst-has? (left-tree tree) value)]
              [else (bst-has? (right-tree tree) value)])]))