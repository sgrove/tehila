(define (game-loop delta)
  ;; Get a new matrix (same as pushing and popping the matrix)
  (with-new-matrix
   (lambda ()
     (draw-floor))))

;; q for quit in this tutorial
(define (handle-keyboard-state delta)
  (if (kb:key-pressed? #\q) (exit)))

(define (draw-floor)
  ;; Texture handles should be assoc lists or something similar,
  ;; it's too tough to remember which texture belong to which handle.
  (textured-quad (u32vector-ref texture-handles 5)
                 (vertex -100 -5  100)
                 (vertex  100 -5  100)
                 (vertex  100 -5 -100)
                 (vertex -100 -5 -100)
                 25 25))

