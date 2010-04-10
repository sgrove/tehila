(define PI 3.14159265)

(define (degrees->radians degrees)
  (/ (* degrees PI) 180))

(define (radians->degrees degrees)
  (/ (* degrees 180) PI))

(define (^2 b)
  (* b b))
