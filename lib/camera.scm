(define camera-position (vertex 0 0 0))
(define camera-velocity (vertex 0 0 0))
(define camera-angle    (vertex 0 0 0))
(define camera-rotation (vertex 0 0 0))
(define camera-orbit-angle  (vertex 0 0 0))
(define camera-orbit-offset 10)

(define (current-camera-position)
  camera-position)

(define (update-camera delta)
  (set! camera-position (map (lambda (a b) (+ a b)) camera-position camera-velocity))
  ;(stop-camera)
  ;(camera-look-at (vertex 0 0 0))
  (set! camera-angle    (map (lambda (a b) (print (+ a b)) (if (equal? (inexact->exact (+ a b)) 0) 0 (remainder 360 (+ a b)))) camera-angle camera-rotation))
  (print (string-append "Position: " (vertex->string camera-position)))
  (print (string-append "Angle   : " (vertex->string camera-angle)))
  (print (string-append "Offset  : " (number->string camera-orbit-offset)))
  (stop-camera)
  (print "------------------------------------------------------------------------------"))
  
(define (turn-camera rotation)
  (print "Turning camera!")
  (print (vertex->string rotation))
  (set! camera-rotation (map (lambda (a b) (+ a b)) camera-rotation rotation)))

;; TODO: Currently 2d. Make it 3d
(define (camera-look-at position)
  (let* ((height (- (vertex-z position) (vertex-z camera-position)))
         (width  (- (vertex-x position) (vertex-x camera-position)))
         (hypo   (sqrt (+ (^2 height) (^2 width))))

         (dummy (print (string-append (number->string (vertex-z position)) " - " (number->string (vertex-z camera-position)) " = " (number->string height))))
         (dummy (print (string-append (number->string (vertex-x position)) " - " (number->string (vertex-x camera-position)) " = " (number->string width))))
         (dummy (print (string-append (number->string height) "^2 + " (number->string width) "^2 = " (number->string hypo) "^2")))
         (dummy (print (string-append "Hypo: " (number->string hypo))))

         (angle  (if (equal? hypo 0.0)
                     0
                     (radians->degrees (asin (/ height hypo)))))
         (old-angle (if (equal? 0 (vertex-y camera-angle))
                         0
                         (vertex-y camera-angle)))
         (turn-angle (- angle old-angle)))
    (print (string-append "To look\n at  " (vertex->string position) " \nfrom " (vertex->string camera-position) " will \nturn " (vertex->string (vertex 0 turn-angle 0)) " degrees\nfrom " (vertex->string camera-angle)))
    (print (string-append (number->string angle) " angle, " (number->string old-angle) " old-angle"))
    (when (not (equal? turn-angle 0))
      (print "not 0"))
    ;(exit))
    (turn-camera (vertex 0 turn-angle 0))))

(define (orbit-camera rotation)
  (print "Orbiting camera!")
  (print (vertex->string rotation))
  (let* ((offset camera-orbit-offset)
         (old-angle (vertex-y camera-angle))
         (old-x (* offset (cos (degrees->radians old-angle))))
         (old-z (* offset (sin (degrees->radians old-angle))))
         ;---
         (new-angle (+ old-angle (vertex-y rotation)))
         (new-x (* offset (cos (degrees->radians new-angle))))
         (new-z (* offset (sin (degrees->radians new-angle)))))

    (print (string-append "(" (number->string old-x) ", " (number->string old-z) ")"))
    (print (string-append "(" (number->string new-x) ", " (number->string new-z) ")"))

    (print (string-append "  (" (number->string old-angle) " d)"))
    (print (string-append "- (" (number->string new-angle) " d)"))
    (print (string-append "= (" (number->string (- new-angle old-angle)) " d)"))
    (print (string-append "O: " (number->string (vertex-y camera-angle)) " N: " (number->string (vertex-y rotation))))
    (print (string-append "+: " (number->string (+ (vertex-y camera-angle) (vertex-y rotation))) " -: " (number->string (- new-angle old-angle))))


    (move-camera (vertex (- new-x old-x) 0 (- new-z old-z)))
    (turn-camera (vertex 0 (- 90 (vertex-y rotation)) 0))))

(define (move-camera delta)
  (set! camera-velocity (map (lambda (a b) (+ a b)) camera-velocity delta)))

(define (move-camera-forward distance)
  (let* ((angle-y (+ 270 (vertex-y camera-angle)))
         (move-x (* distance (cos (degrees->radians angle-y))))
         (move-z (* distance (sin (degrees->radians angle-y))))
         (movement (vertex move-x 0 move-z)))
  (print (string-append "Pointing: " (vertex->string camera-angle)))
  (print (string-append "Angle   : " (number->string (degrees->radians angle-y)) " (" (number->string angle-y) "d)"))
  (print (string-append "Moving  : " (vertex->string movement)))
  (print (string-append "Velocity: " (vertex->string (map (lambda (a b) (+ a b)) movement camera-velocity))))
  (move-camera movement)))

(define (strafe-camera distances)
  (let ((x (vertex-x distances))
        (y (vertex-y distances))
        (z (vertex-z distances)))
    (move-camera (vertex
                  (* x (cos (degrees->radians (+ 90 (vertex-y camera-angle)))))
                  0
                  (* x ( (degrees->radians (+ 90 (vertex-y camera-angle)))))))))


(define (stop-camera)
  (set! camera-velocity (vertex 0 0 0))
  (set! camera-rotation (vertex 0 0 0)))

(define (reset-camera-angle)
  (set! camera-angle    (vertex 0 0 0))
  (set! camera-rotation (vertex 0 0 0)))

(define (reset-camera-position)
  (set! camera-position (vertex 0 0 0))
  (set! camera-velocity (vertex 0 0 0)))

(define (reset-camera)
  (reset-camera-position)
  (reset-camera-angle))

(define (camera-debug debug-function)
  (let ((orbit-center (get-orbit-center)))
    (map debug-function (list (string-append "POSITION: " (number->string (vertex-x camera-position)) ", " (number->string (vertex-y camera-position)) ", " (number->string (vertex-z camera-position)))
                              (string-append "VELOCITY: " (number->string (vertex-x camera-velocity)) ", " (number->string (vertex-y camera-velocity)) ", " (number->string (vertex-z camera-velocity)))
                              (string-append "ANGLE: "    (number->string (vertex-x camera-angle))    ", " (number->string (vertex-y camera-angle))    ", " (number->string (vertex-z camera-angle)))
                              (string-append "ROTATION: " (number->string (vertex-x camera-rotation)) ", " (number->string (vertex-y camera-rotation)) ", " (number->string (vertex-z camera-rotation)))
                              (string-append "ORBIT: "    (number->string (vertex-x camera-orbit-angle)) ", " (number->string (vertex-y camera-orbit-angle))    ", " (number->string (vertex-z camera-orbit-angle)))
                              (string-append "O-CENTER: "    (number->string (vertex-x orbit-center))    ", " (number->string (vertex-y orbit-center))    ", " (number->string (vertex-z orbit-center)))))))

(define (get-orbit-center)
  (let* ((distance 10.0)
         (angle-y (+ 0 (vertex-y camera-angle)))
         (move-x (* distance (cos (degrees->radians angle-y))))
         (move-z (* distance (sin (degrees->radians angle-y)))))
    (vertex-add camera-position (vertex move-x 0 move-z))))


(define (adjust-for-camera)
  (camera-debug print)
    ;(gl:Translated (vertex-x orbit-center) (vertex-y orbit-center) (vertex-z orbit-center))
    ;(gl:Rotated (vertex-y camera-orbit-angle) 0 1 0)
    ;(gl:Translated (- (vertex-x orbit-center)) (- (vertex-y orbit-center)) (- (vertex-z orbit-center))))

  (gl:Rotated (vertex-x camera-angle) 1 0 0)
  (gl:Rotated (vertex-y camera-angle) 0 1 0)
  (gl:Rotated (vertex-z camera-angle) 0 0 1)
  (gl:Translated (- (vertex-x camera-position)) (- (vertex-y camera-position)) (- (vertex-z camera-position))))
  

(define-syntax with-camera-matrix
  (syntax-rules () ((_ body ...)
                    (begin
                      (with-new-matrix
                       (adjust-for-camera
                        body ...
                      (gl:PopMatrix)))))))
