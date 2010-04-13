(define (with-gl type body)
  (gl:Begin type)
  (body)
  (gl:End))

(define (translate . args)
  (apply gl:Translatef args))

(define (rotate . args)
  (apply gl:Rotatef args))

;; (define (vertex? item)
;;   (if (and (equal? (length item) 3)

(define (vertex-x vertex)
  (nth vertex 0))

(define (vertex-y vertex)
  (nth vertex 1))

(define (vertex-z vertex)
  (nth vertex 2))

(define (vertex x y z)
  (list x y z))

(define (vertex-invert vertex)
  (map - vertex))

(define (vertex-truncate vertex #!optional precision)
  (map (lambda (i) (round-to i 0.01)) vertex))

(define (vertex-add vertex-1 vertex-2)
  (map (lambda (a b) (+ a b)) vertex-1 vertex-2))

(define (vertex->string vertex)
  (string-append "(" (number->string (vertex-x vertex)) ", "
                 (number->string (vertex-y vertex)) ", "
                  (number->string (vertex-z vertex)) ")"))

(define (vertex-scale factor vertex)
  (let ((value (map (lambda (x) (* factor x)) vertex)))
    (print (string-append "Scaled! (* " (number->string factor) " " (vertex->string vertex) ") => " (vertex->string value)))
    value))

(define (color x y z)
  (list x y z))

(define (tex-coord x y)
  (list x y))

(define (triangle color1
                  vertex1
                  color2
                  vertex2
                  color3
                  vertex3)
  (gl:Begin gl:TRIANGLES)
  (apply gl:Color3f color1)
  (apply gl:Vertex3f vertex1)
  (apply gl:Color3f color2)
  (apply gl:Vertex3f vertex2)
  (apply gl:Color3f color3)
  (apply gl:Vertex3f vertex3)
  (gl:End))

(define (textured-triangle texture
                           texture-coord-1
                           vertex-1
                           texture-coord-2
                           vertex-2
                           texture-coord-3
                           vertex-3)
    (gl:BindTexture gl:TEXTURE_2D texture)
    (gl:Enable gl:TEXTURE_2D)
    (gl:Begin gl:TRIANGLES)
    (apply gl:TexCoord2f texture-coord-1)
    (apply gl:Vertex3f vertex-1)
    (apply gl:TexCoord2f texture-coord-2)
    (apply gl:Vertex3f vertex-2)
    (apply gl:TexCoord2f texture-coord-3)
    (apply gl:Vertex3f vertex-3)
    (gl:End)
    (gl:Disable gl:TEXTURE_2D))
  
(define (colored-textured-triangle texture
                           color-1
                           texture-coord-1
                           vertex-1
                           color-2
                           texture-coord-2
                           vertex-2
                           color-3
                           texture-coord-3
                           vertex-3)
  ;(print "Drawing a textured triangle")
  (gl:BindTexture gl:TEXTURE_2D texture)
  (gl:Enable gl:TEXTURE_2D)
  (gl:Begin gl:TRIANGLES)
  (apply gl:Color3f color-1)
  (apply gl:TexCoord2f texture-coord-1)
  (apply gl:Vertex3f vertex-1)
  (apply gl:Color3f color-2)
  (apply gl:TexCoord2f texture-coord-2)
  (apply gl:Vertex3f vertex-2)
  (apply gl:Color3f color-3)
  (apply gl:TexCoord2f texture-coord-3)
  (apply gl:Vertex3f vertex-3)
  (gl:End)
  (gl:Disable gl:TEXTURE_2D))

(define (flat-triangle triangle-color
                       vertex-1
                       vertex-2
                       vertex-3)
  (triangle (apply color triangle-color)
            (apply vertex vertex-1)
            (apply color triangle-color)
            (apply vertex vertex-2)
            (apply color triangle-color)
            (apply vertex vertex-3)))

(define (thick-triangle triangle-color
                        x y s)
                                        ; front face
  (flat-triangle (color triangle-color)
                 (vector (+ (- (/ s 2)) x) y 0)
                 (vector x (+ y s) 0)
                 (vector (+ (/ s 2) x) y 0))
                                        ;undersides
  (flat-triangle (color triangle-color)
                 (vector (+ (- (/ s 2)) x) y 0)
                 (vector (+ (- (/ s 2)) x) y 0.25)
                 (vector (+ (/ s 2) x) y 0))

  (flat-triangle (color triangle-color)
                 (vector (+ (- (/ s 2)) x) y 0.25)
                 (vector (+ (/ s 2) x) y 0.25)
                 (vector (+ (/ s 2) x) y 0.0))

                                        ;side-1
  (flat-triangle (color triangle-color)
                 (vector (+ (- (/ s 2)) x) y 0)
                 (vector (+ (- (/ s 2)) x) y 0.25)
                 (vector x (+ y s) 0.25))
  (flat-triangle (color triangle-color)
                 (vector (+ (- (/ s 2)) x) y 0)
                 (vector x (+ y s) 0)
                 (vector x (+ y s) 0.25))
  
                                        ;side-2
  (flat-triangle (color triangle-color)
                 (vector (+ (/ s 2) x) y 0)
                 (vector (+ (/ s 2) x) y 0.25)
                 (vector x (+ y s) 0.25))
  (flat-triangle (color triangle-color)
                 (vector (+ (/ s 2) x) y 0)
                 (vector x (+ y s) 0)
                 (vector x (+ y s) 0.25)))

(define (flat-quad quad-color
                   vertex-1
                   vertex-2
                   vertex-3
                   vertex-4)

  (quad quad-color
        vertex-1
        quad-color
        vertex-2
        quad-color
        vertex-3
        quad-color
        vertex-4))

(define (quad color-1
              vertex-1
              color-2
              vertex-2
              color-3
              vertex-3
              color-4
              vertex-4)
  
  (gl:Begin gl:QUADS)
  (apply gl:Color3f color-1)
  (apply gl:Vertex3f vertex-1)
  (apply gl:Color3f color-2)
  (apply gl:Vertex3f vertex-2)
  (apply gl:Color3f color-3)
  (apply gl:Vertex3f vertex-3)
  (apply gl:Color3f color-4)
  (apply gl:Vertex3f vertex-4)
  (gl:End))

(define (textured-quad texture
                       upper-left
                       upper-right
                       lower-right
                       lower-left
                       #!optional
                       repeat-x
                       repeat-y
                       flip-texture)
  (let* ((rx (if repeat-x repeat-x 1))
         (ry (if repeat-y repeat-y 1))
         (fh (if (and flip-texture (or (equal? 'flip flip-texture)
                                       (equal? 'flip-horizontal flip-texture))) -1 1))
         (fv (if (and flip-texture (or (equal? 'flip flip-texture)
                                       (equal? 'flip-vertical flip-texture))) -1 1))
         (texture-lower-left  (tex-coord 0           0))
         (texture-upper-left  (tex-coord 0           (* 1 ry fv)))
         (texture-upper-right (tex-coord (* 1 rx fh) (* 1 ry fv)))
         (texture-lower-right (tex-coord (* 1 rx fh) 0)))


    (textured-triangle texture
                       texture-lower-left
                       lower-left
                       texture-upper-left
                       upper-left
                       texture-lower-right
                       lower-right)
    
    (textured-triangle texture
                       texture-upper-left
                       upper-left
                       texture-upper-right
                       upper-right
                       texture-lower-right
                       lower-right)))
  

;; Matrix utils
(define-syntax with-new-matrix-m
  (syntax-rules () ((_ body ...)
                    (begin
                      (gl:PushMatrix)
                      body ...
                      (gl:PopMatrix)))))

(define (with-new-matrix f)
  (gl:PushMatrix)
  (f)
  (gl:PopMatrix))

(define (bottomless-cube top-texture
                         side-texture
                         position
                         scale
                         #!optional flip-texture)
  (set! *cube-debugger* (/ (- (current-milliseconds) *start-time*) 100000))

  (with-new-matrix
   (gl:Translated (vertex-x position) (vertex-y position) (vertex-z position))
   (textured-quad top-texture
                  (vertex 0 1 1)
                  (vertex 1 1 1)
                  (vertex 1 1 0)
                  (vertex 0 1 0)
                  1 1 flip-texture)
  
   ; sides
   ;;  back
   (textured-quad side-texture
                  (vertex 0 1 1)
                  (vertex 1 1 1)
                  (vertex 1 0 1)
                  (vertex 0 0 1))

   ;; front
   (textured-quad side-texture
                  (vertex 0 1 0)
                  (vertex 1 1 0)
                  (vertex 1 0 0)
                  (vertex 0 0 0))

   ;;  left
   (textured-quad side-texture
                  (vertex 0 1 0)
                  (vertex 0 1 1)
                  (vertex 0 0 1)
                  (vertex 0 0 0))

   ;; right
   (textured-quad side-texture
                  (vertex 1 1 0)
                  (vertex 1 1 1)
                  (vertex 1 0 1)
                  (vertex 1 0 0))))

