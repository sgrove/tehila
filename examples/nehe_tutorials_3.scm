;; Tutorial-specific settings
(define *clear-color* '(0 0 0 0))

(define (game-loop delta)
  ;; Get a new matrix (same as pushing and popping the matrix)
  (with-new-matrix
   (lambda ()

     ;; Move left 1.5 units and "out of" the screen 6 units
     (translate -1.5 0.0 -6.0)

     ;; Draw a colored triangle
     (triangle (color 1 0 0)    ;; Red
               (vertex 0 1 0)   ;; Top
               (color 0 1 0)    ;; Green
               (vertex -1 -1 0) ;; Bottom Left
               (color 0 0 1)    ;; Blue
               (vertex 1 -1 0)) ;; Bottom Right

     ;; Move right 3 units
     (translate 3 0 0)

     ;; Draw a flat-colored (one-color) quad
     (flat-quad (color 0 0 1)     ;; Blue
                (vertex -1  1 0)  ;; Top Left
                (vertex  1  1 0)  ;; Top Right
                (vertex  1 -1 0)  ;; Bottom Right
                (vertex -1 -1 0)) ;; Bottom Left     
     )))

;; q for quit in this tutorial
(define (handle-keyboard-state delta)
  (if (kb:key-pressed? #\q) (exit)))

