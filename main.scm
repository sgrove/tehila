(define (pre-main-hook)
  (move-camera (vertex 5 10 5))
  ;(turn-camera (vertex 45 225 0))
  )


(define (game-looper delta)
  ;(print "Do something here!")
  ;(print delta)
  (let* ((total-time (- (current-milliseconds) *start-time*))
         (seconds (/ (inexact->exact (truncate total-time)) 1000))
         (current-texture (inexact->exact (truncate (remainder seconds 2)))))
                                        ;(print seconds)
    ;(print current-texture)
    ;(print delta)
    ;(move-camera-forward (- 0.1))
    (update-camera delta)
    (adjust-for-camera)
    ;(camera-debug print)

      ;; (do ((x -20.0 (+ x 1)))  ((> x 20))
      ;;   (do ((z -2.0 (+ z 1))) ((> z 2))
      ;;     (with-new-matrix
      ;;      (textured-quad  (u32vector-ref texture-handles 2)
      ;;                      (vertex x -0.5 z)
      ;;                      (vertex (+ x 1) -0.5  z)
      ;;                      (vertex (+ x 1) -0.5 (- z 1))
      ;;                      (vertex x -0.5 (- z 1))))))

    (draw-floor)
    (draw-trees)
    (draw-custom-characters)

    (with-new-matrix
     (flat-triangle (color 0.25 0.5 0.75)
                    (vertex -1 1 -2)
                    (vertex 1 1 -2)
                    (vertex 1 0 -2)))))




(define tree-count 10)
(define tree-texture-handle 3)

(define tree-positions
  (let* ((positions (make-vector tree-count)))
    ;; (do ((tree 0 (+ 1 tree))) ((equal? tree tree-count))
      ;; (vector-set! positions tree (vertex (/ (- (random 1000) 500) 100)
      ;;                                      0
      ;;                                      (/ (- (random 1000) 500) 100))))
    (vector-set! positions 0 (vertex -10 0 1))
    (vector-set! positions 1 (vertex -10 0 2))
    (vector-set! positions 2 (vertex -10 0 3))
    (vector-set! positions 3 (vertex -10 0 4))
    (vector-set! positions 4 (vertex -10 0 5))
    (vector-set! positions 5 (vertex 10 0 6))
    (vector-set! positions 6 (vertex 10 0 7))
    (vector-set! positions 7 (vertex 10 0 8))
    (vector-set! positions 8 (vertex 10 0 9))
    (vector-set! positions 9 (vertex 10 0 10))
    positions))

(define tree-heights
  (let* ((heights (make-vector tree-count)))
    (do ((tree 0 (+ 1 tree))) ((equal? tree tree-count))
      (vector-set! heights tree (+ (/ (random 8) 2) 2)))
    heights))

(define tree-rotations
  (let* ((rotations (make-vector tree-count)))
    (do ((tree 0 (+ 1 tree))) ((equal? tree tree-count))
      ;(vector-set! rotations tree (/ (- (random 1080) 720) 2)))
      (vector-set! rotations tree 0))
    rotations))

(define (draw-tree n)
  (let ((position (vector-ref tree-positions n))
        (rotation (vector-ref tree-rotations n))
        (height (vector-ref tree-heights n)))
    ;(print (vertex->string position))
    (with-new-matrix
     (gl:Rotatef    rotation 0 1 0)
     (gl:Translatef (vertex-x position) (vertex-y position) (vertex-z position))
     (textured-quad (u32vector-ref texture-handles tree-texture-handle)
                    (vertex 0 height 0)
                    (vertex 1 height 0)
                    (vertex 1 0 0)
                    (vertex 0 0 0)))))

(define (draw-trees)
  (do ((counter 0 (+ counter 1))) ((equal? counter tree-count))
    (draw-tree counter)))

;; ----- Characters -----

(define character-count 20)
(define character-texture-handle 0)

(define character-positions
  (let* ((positions (make-vector character-count)))
    (do ((character 0 (+ 1 character))) ((equal? character character-count))
      ;;(vector-set! positions character (vertex 0 -5 0)))
       (vector-set! positions character (vertex (/ (- (random 1000) 500) 1000)
                                           -0
                                           (/ (- (random 1000) 500) 1000))))
    positions))

(define character-velocities
  (let* ((velocities (make-vector character-count)))
    (do ((character 0 (+ 1 character))) ((equal? character character-count)))
    velocities))

(define (update-character-positions)
    (do ((character 0 (+ 1 character))) ((equal? character character-count))
      (vector-set! character-positions character
                   (vertex-add (vector-ref character-positions character) (vector-ref character-velocities character)))
      (vector-set! character-velocities character (vertex 0 0 0))))

(define character-rotations
  (let* ((rotations (make-vector character-count)))
    (do ((character 0 (+ 1 character))) ((equal? character character-count))
      (vector-set! rotations character (/ (- (random 1080) 720) 2)))
    rotations))

(define (characters-wander)
  (do ((character 0 (+ 1 character))) ((equal? character character-count))
    (vector-set! character-velocities character 
                 (vertex (/ (- (random 1) 1) 10) 0 (/ (- (random 1) 1) 10)))))

(define (draw-custom-characters)
  (draw-character (vertex -10.0 1 5.0) 90 1)
  (draw-character (vertex -9.0  1 5.0) 90 1)
  (draw-character (vertex -8.0  1 5.0) 90 1)
  (draw-character (vertex -7.0  1 5.0) 90 1)
  (draw-character (vertex -6.0  1 5.0) 90 1)
  (draw-character (vertex -5.0  1 5.0) 90 1)

  (draw-character (vertex -10.0 1 4.0) 90 1)
  (draw-character (vertex -9.0  1 4.0) 90 1)
  (draw-character (vertex -8.0  1 4.0) 90 1)
  (draw-character (vertex -7.0  1 4.0) 90 1)
  (draw-character (vertex -6.0  1 4.0) 90 1)
  (draw-character (vertex -5.0  1 4.0) 90 1)

  (draw-character (vertex -10.0 1 6.0) 90 1)
  (draw-character (vertex -9.0  1 6.0) 90 1)
  (draw-character (vertex -8.0  1 6.0) 90 1)
  (draw-character (vertex -7.0  1 6.0) 90 1)
  (draw-character (vertex -6.0  1 6.0) 90 1)
  (draw-character (vertex -5.0  1 6.0) 90 1)

  (draw-character (vertex -10.0 1 7.0) 90 1)
  (draw-character (vertex -9.0  1 7.0) 90 1)
  (draw-character (vertex -8.0  1 7.0) 90 1)
  (draw-character (vertex -7.0  1 7.0) 90 1)
  (draw-character (vertex -6.0  1 7.0) 90 1)
  (draw-character (vertex -5.0  1 7.0) 90 1)  

  ; v's
  (draw-character (vertex -10.0 1 -1.0) 90 1)
  (draw-character (vertex -9.0 1 -2.0) 90 1)
  (draw-character (vertex -8.0 1 -3.0) 90 1)
  (draw-character (vertex -7.0 1 -4.0) 90 1)
  (draw-character (vertex -6.0 1 -3.0) 90 1)
  (draw-character (vertex -5.0 1 -2.0) 90 1)
  (draw-character (vertex -4.0 1 -1.0) 90 1)

  (draw-character (vertex -7.0 1 -5.0) 90 1)
  (draw-character (vertex -6.0 1 -4.0) 90 1)
  (draw-character (vertex -5.0 1 -3.0) 90 1)
  (draw-character (vertex -4.0 1 -2.0) 90 1)
  (draw-character (vertex -3.0 1 -3.0) 90 1)
  (draw-character (vertex -2.0 1 -4.0) 90 1)
  (draw-character (vertex -1.0 1 -5.0) 90 1)
)
                        
(define (draw-character position
                        rotation
                        scale)
  (let ((texture-number (remainder (- (current-milliseconds) *start-time*) 2)))
    (with-new-matrix
     (gl:Rotatef    rotation 0 1 0)
     (gl:Translatef (vertex-x position) (vertex-y position) (vertex-z position))
     (textured-quad (u32vector-ref texture-handles texture-number)
                    (vertex 0 1 0)
                    (vertex 1 1 0)
                    (vertex 1 0 0)
                    (vertex 0 0 0)))))

(define (draw-character-from-array n)
  (characters-wander)
  (update-character-positions)
  (let ((position (vector-ref character-positions n))
        (rotation (vector-ref character-rotations n)))
    ;(print (vertex->string position))
    (with-new-matrix
     ;(gl:Rotatef    rotation 0 1 0)
     (gl:Translatef (vertex-x position) (vertex-y position) (vertex-z position))
     (textured-quad (u32vector-ref texture-handles character-texture-handle)
                    (vertex 0 1 0)
                    (vertex 1 1 0)
                    (vertex 1 0 0)
                    (vertex 0 0 0)))))

(define (draw-characters) 
  (do ((counter 0 (+ counter 1))) ((equal? counter character-count))
    (draw-character-from-array counter)))


;; floor

(define (draw-floor)
  (let ((grass-texture (u32vector-ref texture-handles 5))
        (water-texture (u32vector-ref texture-handles 6))
        (grass-water-transition-texture (u32vector-ref texture-handles 7))
        (grid-texture (u32vector-ref texture-handles 2))
        (base -5))

    ; river
    (do ((x 0 (+ x 1))) ((> x 2))
      (do ((z 0 (+ z 1))) ((> z 10))
        (bottomless-cube water-texture
                         water-texture
                         (vertex x 0 z)
                         1)))

    ; land
    (do ((x 4 (+ x 1))) ((> x 10))
      (do ((z 0 (+ z 1))) ((> z 10))
        (bottomless-cube grass-texture
                         grass-texture
                         (vertex x 0 z)
                         1)))

    (do ((z 0 (+ z 1))) ((> z 10))
      (bottomless-cube grass-water-transition-texture
                       grid-texture
                       (vertex 3 0 z)
                       1))

    (do ((z 0 (+ z 1))) ((> z 10))
      (bottomless-cube grass-water-transition-texture
                       grid-texture
                       (vertex -1 0 z)
                       1
                       'flip-horizontal))

    (do ((x -10 (+ x 1))) ((equal? x -1))
      (do ((z 0 (+ z 1))) ((> z 10))
        (bottomless-cube grass-texture
                         grass-texture
                         (vertex x 0 z)
                         1)))))


(define (handle-keyboard-state delta)
  (let* ((delta (+ (- (current-milliseconds) *last-frame*) 1))
         (turn-sensitivity  (* 1.0 delta))
         (move-sensitivity (* 0.01 delta))
         (walk-length (* 5 delta)))
    ;(print delta)
    (if (kb:key-pressed? glut:KEY_LEFT)  (turn-camera (vertex 0 (- turn-sensitivity) 0)))
    (if (kb:key-pressed? glut:KEY_RIGHT) (turn-camera (vertex 0 turn-sensitivity 0)))
    (if (kb:key-pressed? glut:KEY_UP)    (move-camera-forward walk-length))
    (if (kb:key-pressed? glut:KEY_DOWN)  (move-camera-forward (- walk-length)))

    ;; (if (kb:key-pressed? glut:KEY_LEFT)  (iso-move-camera (vertex 1 0 0)))
    ;; (if (kb:key-pressed? glut:KEY_RIGHT) (iso-move-camera (vertex -1 0 0)))
    ;; (if (kb:key-pressed? glut:KEY_UP)    (iso-move-camera (vertex 0 0 1)))
    ;; (if (kb:key-pressed? glut:KEY_DOWN)  (iso-move-camera (vertex 0 0 -1)))

    ;; (if (kb:key-pressed? #\q)  (iso-turn-camera (vertex 0 1 0)))
    ;; (if (kb:key-pressed? #\e)  (iso-turn-camera (vertex 0 -1 0)))

    (if (kb:key-pressed? #\a) (strafe-camera (vertex walk-length 0 0)))
    (if (kb:key-pressed? #\d) (strafe-camera (vertex (- walk-length) 0 0)))
    (if (kb:key-pressed? #\a) (strafe-camera (vertex walk-length 0 0)))
    (if (kb:key-pressed? #\d) (strafe-camera (vertex (- walk-length) 0 0)))
    (if (kb:key-pressed? #\w) (strafe-camera (vertex 0 walk-length 0)))
    (if (kb:key-pressed? #\s) (strafe-camera (vertex 0 (- walk-length) 0)))
    (if (kb:key-pressed? #\z) (move-camera (vertex 0  walk-length 0)))
    (if (kb:key-pressed? #\x) (move-camera (vertex 0 (- walk-length) 0)))

    (if (kb:key-pressed? #\r) (turn-camera (vertex 0 (- turn-sensitivity) 0)))
    (if (kb:key-pressed? #\f) (turn-camera (vertex 0 turn-sensitivity 0)))

    (if (kb:key-pressed? #\q) (orbit-camera (vertex 0  10 0)))
    (if (kb:key-pressed? #\e) (orbit-camera (vertex 0 -10 0)))

    (if (kb:key-pressed? #\space)  (returnable-repl))))
