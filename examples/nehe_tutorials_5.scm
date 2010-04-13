;; Tutorial-specific settings
(define *clear-color* '(0 0 0 0))

(define (game-loop delta)
  (let* ((total-time (- (current-milliseconds) *start-time*))
         (seconds (/ (inexact->exact (truncate total-time)) 1000))
         (current-texture (inexact->exact (truncate (remainder seconds 2))))
         (triangle-rotation (/ total-time 4))
         (quad-rotation (/ total-time 2)))

    ;; Get a new matrix (same as pushing and popping the matrix)
    (with-new-matrix

     ;; Move left 1.5 units and "out of" the screen 6 units
     (gl:Translatef -1.5 0.0 -6.0)

     ;; Rotate about the Y axis before we draw the triangle
     (gl:Rotatef triangle-rotation 0 1 0)

     ;; Draw one face of the pyramid (a colored triangle)
     (triangle (color   1  0  0)  ;; Red
               (vertex  0  1  0)  ;; Top
               (color   0  1  0)  ;; Green
               (vertex -1 -1  1)  ;; Bottom Left
               (color   0  0  1)  ;; Blue
               (vertex  1 -1  1)) ;; Bottom Right

    (triangle (color   1  0  0)  ;; Red
              (vertex  0  1  0)  ;; Top
              (color   0  0  1)  ;; Blue
              (vertex  1 -1  1)  ;; Bottom Left
              (color   0  1  0)  ;; Green
              (vertex  1 -1 -1)) ;; Bottom Right

    (triangle (color   1  0  0)  ;; Red
              (vertex  0  1  0)  ;; Top
              (color   0  1  0)  ;; Green
              (vertex  1 -1 -1)  ;; Bottom Left
              (color   0  0  1)  ;; Blue
              (vertex -1 -1 -1)) ;; Bottom Right

    (triangle (color   1  0  0)  ;; Red
              (vertex  0  1  0)  ;; Top
              (color   0  0  1)  ;; Blue
              (vertex -1 -1 -1)  ;; Bottom Left
              (color   0  1  0)  ;; Green
              (vertex -1 -1  1)) ;; Bottom Right
     )

    ;; Reset to the default matrix
    (with-new-matrix

     ;; Move left 1.5 units and "out of" the screen 6 units
     (gl:Translatef 1.5 0.0 -7.0)

     ;; Rotate about the X, Y, and Z axis before we draw the triangle
     (gl:Rotatef quad-rotation 1 1 1)

     ;; Draw a flat-colored (one-color) quad
     (flat-quad (color 0 1 0)      ;; Green
                (vertex  1  1 -1)  ;; Top Left
                (vertex -1  1 -1)  ;; Top Right
                (vertex -1  1  1)  ;; Bottom Right
                (vertex  1  1  1)) ;; Bottom Left     

     (flat-quad (color 1 0.5 1)    ;; Orange
                (vertex  1 -1  1)  ;; Top Left
                (vertex -1 -1  1)  ;; Top Right
                (vertex -1 -1 -1)  ;; Bottom Right
                (vertex  1 -1 -1)) ;; Bottom Left 

     (flat-quad (color 1 0 0)      ;; Red
                (vertex  1  1  1)  ;; Top Left
                (vertex -1  1  1)  ;; Top Right
                (vertex -1 -1  1)  ;; Bottom Right
                (vertex  1 -1  1)) ;; Bottom Left 

     (flat-quad (color 1 1 0)      ;; Yellow
                (vertex  1 -1 -1)  ;; Top Left
                (vertex -1 -1 -1)  ;; Top Right
                (vertex -1  1 -1)  ;; Bottom Right
                (vertex  1  1 -1)) ;; Bottom Left      

     (flat-quad (color 0 0 1)      ;; Blue
                (vertex -1  1  1)  ;; Top Left
                (vertex -1  1 -1)  ;; Top Right
                (vertex -1 -1 -1)  ;; Bottom Right
                (vertex -1 -1  1)) ;; Bottom Left      

     (flat-quad (color 1 0 1)      ;; Violet
                (vertex  1  1 -1)  ;; Top Left
                (vertex  1  1  1)  ;; Top Right
                (vertex  1 -1  1)  ;; Bottom Right
                (vertex  1 -1 -1)) ;; Bottom Left      
     )))

;; No keyboard control in this tutorial
(define (handle-keyboard-state delta)
  '())
