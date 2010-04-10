(define *debug-mode* #f)

(define *window-title* "Schope")

(define *window-resolution* '(640 480))
(define *window-position* '(100 100))
(define *clear-color* '(0 0 0 0))
(define *clear-depth* 1.0)

(define *ignore-key-repeat* #f)

(define *shade-model* gl:SMOOTH)

(define (pre-main-hook)
  (move-camera (vertex 5 10 5))
  (turn-camera (vertex 45 225 0)))

(define *texture-files* '("rpg-char-4.bmp" "rpg-char-4-2.bmp" "grid.bmp" "tree.bmp" "corner_test.bmp" "grass.bmp"))
