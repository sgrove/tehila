;; Tutorial-specific settings
(define *clear-color* '(0 0 0 0))

(define (game-loop delta)
    ;; Get a new matrix (same as pushing and popping the matrix)
    (with-new-matrix

     ;; Move left 1.5 units and "out of" the screen 6 units
     (gl:Translatef -1.5 0.0 -6.0)

     ;; Draw a flat-colored (one-color) triangle
     (flat-triangle (color 1 1 1)    ;; White
                    (vertex 0 0 0)   ;; Top
                    (vertex -1 -1 0) ;; Bottom Left
                    (vertex 1 -1 0)) ;; Bottom Right

     ;; Move right 3 units
     (gl:Translatef 3 0 0)

     ;; Draw a flat-colored (one-color) quad
     (flat-quad (color 1 1 1)     ;; White
                (vertex -1  1 0)  ;; Top Left
                (vertex  1  1 0)  ;; Top Right
                (vertex  1 -1 0)  ;; Bottom Right
                (vertex -1 -1 0)) ;; Bottom Left     
     ))

;; No keyboard control in this tutorial
(define (handle-keyboard-state delta)
  '())
