(require-extension gl)
(require-extension glu)
(require-extension glut)

(set! *start-time* (current-milliseconds))

(define (init)
  (gl:ClearColor 0.0 0.0 0.0 0.0)
  (gl:ShadeModel gl:SMOOTH))

(define (with-gl type body)
  (gl:Begin type)
  (body)
  (gl:End))


(define (triangle c1-r c1-g c1-b
                  x1 y1 z1
                  c2-r c2-g c2-b
                  x2 y2 z2
                  c3-r c3-g c3-b
                  x3 y3 z3)
  (with-gl gl:TRIANGLES
   (lambda ()
     (gl:Color3f c1-r c1-g c1-b)
     (gl:Vertex3f x1 y1 z1)
     (gl:Color3f c2-r c2-g c2-b)
     (gl:Vertex3f x2 y2 z2)
     (gl:Color3f c3-r c3-g c3-b)
     (gl:Vertex3f x3 y3 z3)
     )))


(define (flat-triangle r g b
                       x1 y1 z1
                       x2 y2 z2
                       x3 y3 z3)
  (triangle r g b
            x1 y1 z1
            r g b
            x2 y2 z2
            r g b
            x3 y3 z3))

(define (thick-triangle r g b
                        x y s)
  ; front face
  (flat-triangle r g b
                 (+ (- (/ s 2)) x) y 0
                 x (+ y s) 0
                 (+ (/ s 2) x) y 0)
  ;undersides
  (flat-triangle r g b
                 (+ (- (/ s 2)) x) y 0
                 (+ (- (/ s 2)) x) y 0.25
                 (+ (/ s 2) x) y 0)
  (flat-triangle r g b
                 (+ (- (/ s 2)) x) y 0.25
                 (+ (/ s 2) x) y 0.25
                 (+ (/ s 2) x) y 0.0)

  ;side-1
  (flat-triangle r g b
                 (+ (- (/ s 2)) x) y 0
                 (+ (- (/ s 2)) x) y 0.25
                 x (+ y s) 0.25)
  (flat-triangle r g b
                 (+ (- (/ s 2)) x) y 0
                 x (+ y s) 0
                 x (+ y s) 0.25)
  
  ;side-2
  (flat-triangle r g b
                 (+ (/ s 2) x) y 0
                 (+ (/ s 2) x) y 0.25
                 x (+ y s) 0.25)
  (flat-triangle r g b
                 (+ (/ s 2) x) y 0
                 x (+ y s) 0
                 x (+ y s) 0.25))


(define (triangles-4 delta)
  (gl:PushMatrix)
  (gl:Rotated (* 90 delta) 0 1 0)
  (do ((i 0 (+ i 1))
       (a 10 (- a 1)))
      ((> i 4))
    (begin
      (gl:Rotated 90 0 1 0)
      (gl:Translated 0.8 0 1)
      (thick-triangle 0.65 0.65 0
                      0 0 1)
      (thick-triangle 0.65 0.65 0
                      -0.5 -1 1)
      (thick-triangle 0.65 0.65 0
                      0.5 -1 1)))

  ; flip the matrix
  (gl:Translated 0 2 0)
  (gl:Rotated 180 0 0 1)


  (do ((i 0 (+ i 1))
       (a 10 (- a 1)))
      ((> i 4))
    (begin
      (gl:Rotated 90 0 1 0)
      (gl:Translated 0.8 0 1)
      (thick-triangle 0.65 0.65 0
                      0 0 1)
      (thick-triangle 0.65 0.65 0
                      -0.5 -1 1)
      (thick-triangle 0.65 0.65 0
                      0.5 -1 1)))
  (gl:PopMatrix))

(define (display)
  (gl:Clear gl:COLOR_BUFFER_BIT)
  (gl:MatrixMode gl:MODELVIEW)
  (let ((delta (/ (- *start-time* (current-milliseconds)) 100)))
    (print delta)
    (triangles-4 (/ delta 4))
    (gl:Flush)))

(define (reshape width height)
  (gl:Viewport 0 0 width height)
  (gl:MatrixMode gl:PROJECTION)
  (gl:LoadIdentity)
  (glu:Perspective 60.0 (/ width height) 1.0 30.0)
  (gl:MatrixMode gl:MODELVIEW)
  (gl:LoadIdentity)
  (gl:Translatef 0.0 0.0 (- 3.6)))

(define (keyboard key x y)
  (if (equal? key 27)
      (exit 0)))

(define (render-loop delta)
  (glut:PostRedisplay)
  (glut:TimerFunc 0 render-loop 0))

(define (main)
  (glut:InitWindowSize 250 250)
  (glut:InitWindowPosition 100 100)
  (glut:CreateWindow "Schemer's Hope")
  (init)
  (glut:DisplayFunc display)
  (glut:ReshapeFunc reshape)
  (glut:KeyboardFunc keyboard)
  (glut:TimerFunc 1 render-loop 0)
  (glut:MainLoop))

(main)
