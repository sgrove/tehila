(define *debug-mode* #f)

(define *window-title* "Schope")

(define *window-resolution* '(640 480))
(define *window-position* '(100 100))
(define *clear-color* '(1 1 1 0))
(define *clear-depth* 1.0)
(define *display-mode* (+ glut:DOUBLE glut:RGBA glut:DEPTH))

(define *ignore-key-repeat* #t)

(define *shade-model* gl:SMOOTH)

(define *texture-files* '("resources/grid.bmp" "resources/corner_test.bmp" "resources/example.bmp"))

(define *default-debug-function* print)
