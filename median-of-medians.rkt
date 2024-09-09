#lang racket

(provide median-of-medians list-has-five-or-fewer? insertion-sort)

;; Helper function: Insertion sort for small lists of size <= 5
(define (insertion-sort number-list)
  (if (null? number-list)
      '()
      (let insert ((current-number (car number-list))
                   (sorted-list (insertion-sort (cdr number-list))))
        (if (null? sorted-list)
            (list current-number)
            (if (<= current-number (car sorted-list))
                (cons current-number sorted-list)
                (cons (car sorted-list) (insert current-number (cdr sorted-list))))))))

;; Helper function: Check if the list has 5 or fewer elements
(define (list-has-five-or-fewer? number-list)
  (let count-up-to-six ((lst number-list) (count 0))
    (cond
      [(> count 5) #f]
      [(null? lst) #t]
      [else (count-up-to-six (cdr lst) (+ count 1))])))

;; Helper function: Find the median of a list of up to 5 elements
(define (find-median small-list)
  (let* ((sorted-list (insertion-sort small-list))
         (list-length (let count-elements ((current-list sorted-list) (count 0))
                        (if (null? current-list)
                            count
                            (count-elements (cdr current-list) (+ count 1)))))
         (median-index (floor (/ list-length 2))))
    (if (= list-length 0)
        '()
        (list-ref sorted-list median-index))))

;; Helper function: Split a list into groups of up to 5 elements
(define (split-into-groups-of-five number-list)
  (if (null? number-list)
      '()
      (cons (take number-list 5)
            (split-into-groups-of-five (drop number-list 5)))))

;; Median of Medians pivot selection
(define (median-of-medians number-list)
  (let* ((groups-of-five (split-into-groups-of-five number-list))
         (medians (map find-median groups-of-five)))
    (if (list-has-five-or-fewer? medians)
        (find-median medians)
        (median-of-medians medians))))