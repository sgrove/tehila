;; Depends on original camera system
(define (iso-turn-camera rotation)
  (print "Turning camera!")
  (print (vertex->string rotation))
  (set! camera-rotation (map (lambda (a b) (+ a (* 90 b))) camera-rotation rotation)))

(define (iso-move-camera delta)
  (set! camera-velocity (map (lambda (a b) (+ a b)) camera-velocity delta)))

