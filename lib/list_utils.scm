(define (first lst)
  (car lst))

(define (rest lst)
  (cdr lst))

(define (reduce fn base-value lst)
  (if (null? lst)
      base-value
      (fn (car lst)
          (reduce fn base-value (cdr lst)))))

(define (nth lst index)
  (if (equal? 0 index)
      (car lst)
      (nth (cdr lst) (- index 1))))

(define (sublist lst start finish)
  (if (< start 1)
      (if (< finish 1)
          '()
          (cons (car lst) (sublist (cdr lst) 0 (- finish 1))))
      (sublist (cdr lst) (- start 1) (- finish 1))))
