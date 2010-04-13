(define PI 3.14159265)

(define (degrees->radians degrees)
  (/ (* degrees PI) 180))

(define (radians->degrees degrees)
  (/ (* degrees 180) PI))

(define (^2 b)
  (* b b))

(define (round-to n d)
  (if (= 0 n) n (/ (round (* n (/ 1.0 d))) (/ 1.0 d))))
