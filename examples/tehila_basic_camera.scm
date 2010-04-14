;; Tutorial-specific settings
(define *clear-color* '(0 0 0 0))

(define (game-loop delta)
  (let* ((total-time (- (current-milliseconds) *start-time*))
         (triangle-rotation (/ total-time 4))
         (quad-rotation (/ total-time 2))
         (object-count 20))

    (update-camera delta)
    (adjust-for-camera)

    ;; Circle of triangles around the origin (0, 0, 0)
    (do ((angle 0 (+ angle (/ 360 object-count)))) ((> angle 360))

      ;; Get a new matrix (same as pushing and popping the matrix)
      (with-new-matrix
       (lambda ()
         
         ;; Rotate about the Y axis before we move the pyramid
         (rotate angle 0 1 0)

         ;; Move "out of" the screen 15 units
         (translate 0 0.0 -15)

         ;; Rotate about the Y axis before we draw the pyramid
         (rotate triangle-rotation 0 1 0)
         
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
         )))
      
      ;; Reset to the default matrix
      (with-new-matrix
       (lambda ()
         
         ;; Move left 1.5 units and "out of" the screen 6 units
         (translate 0.0 0.0 -3.0)
         
         ;; Rotate about the X, Y, and Z axis before we draw the cube
         (rotate quad-rotation 0.25 1 1)
         
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
         
         (flat-quad (color   1  0  1)  ;; Violet
                    (vertex  1  1 -1)  ;; Top Left
                    (vertex  1  1  1)  ;; Top Right
                    (vertex  1 -1  1)  ;; Bottom Right
                    (vertex  1 -1 -1)) ;; Bottom Left      
         ))))

(define (handle-keyboard-state delta)
  ;; bind keys to actions
  (let* ((walk-speed 0.01)
         (turn-speed 0.10)
         (key-map
          ;; Note: Strafe is essentially broken right now. Need to fix it.
          `((#\a . ,(lambda () (strafe-camera (vertex (- walk-speed) 0 0))))
            (#\d . ,(lambda () (strafe-camera (vertex walk-speed 0 0))))
            (#\w . ,(lambda () (move-camera-forward walk-speed)))
            (#\s . ,(lambda () (move-camera-forward (- walk-speed))))

            ;; Move vertically
            (#\z . ,(lambda () (move-camera (vertex 0 (- walk-speed) 0))))
            (#\x . ,(lambda () (move-camera (vertex 0 walk-speed 0))))

            ;; Rotate around the Z and X axis (note: disorienting)
            (#\q . ,(lambda () (turn-camera (vertex 0 0 (- turn-speed)))))
            (#\e . ,(lambda () (turn-camera (vertex 0 0 turn-speed ))))
            (#\r . ,(lambda () (turn-camera (vertex (- turn-speed) 0 0))))
            (#\f . ,(lambda () (turn-camera (vertex turn-speed 0 0 ))))

            ;; Normal walking controls via arrow keys
            (,kb:LEFT  . ,(lambda () (turn-camera (vertex 0 (- turn-speed) 0))))
            (,kb:RIGHT . ,(lambda () (turn-camera (vertex 0 turn-speed 0))))
            (,kb:UP    . ,(lambda () (move-camera-forward walk-speed)))
            (,kb:DOWN  . ,(lambda () (move-camera-forward (- walk-speed))))

            ;; Get a REPL. You can check the world state with things like
            ;; (camera-debug)
            (#\space . ,(lambda () (returnable-repl)))
            
            ;; q to quit
            (#\q . ,(lambda () (exit))))))
    
    ;; execute actions for keys in *keyboard-state*
    (for-each (lambda (key)
                (and-let* ((handler (alist-ref key key-map)))
                          (handler)))
              *keyboard-state*)))
