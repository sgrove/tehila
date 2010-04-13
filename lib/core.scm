(require-extension lolevel)
(require-extension gl)
(require-extension glu)
(require-extension glut)
(require-extension srfi-4)

;; Hooks. Load early so they can be overridden anywhere
(define (pre-main-hook) '())
(define (post-main-hook) '())
(define (pre-init-hook) '())
(define (post-init-hook) '())
(define (pre-reshape-hook) '())
(define (post-reshape-hook) '())
(define (pre-render-hook) '())
(define (post-render-hook) '())
(define (pre-display-hook) '())
(define (post-display-hook) '())

;; General helpers
(load "lib/exceptions.scm")
(load "lib/math_utils.scm")
(load "lib/list_utils.scm")
(load "lib/binary_utils.scm")
(load "lib/image_utils.scm")
(load "lib/repl_utils.scm")

;; Graphics/OpenGL helpers
(load "lib/gl_utils.scm")
(load "lib/texture_utils.scm")
(load "lib/keyboard.scm")
(load "lib/camera.scm")
;;(load "lib/iso_camera.scm")

;; User settings
(load "config/settings.scm")

(if *debug-mode*
    (load "lib/gl_debug_utils.scm"))

(print "All helpers loaded")
(print "Loading custom logic...")

;; User's logic
(load *logic-file*)
(print "Scaffolding application...")

(set! *start-time* (current-milliseconds))
(set! *last-frame* (current-milliseconds))
(set! *texture-count* 0)

(define texture-handles (make-u32vector (length *texture-files*)))

(define (init)
  (gl:ShadeModel gl:SMOOTH)
  (gl:ClearDepth *clear-depth*)
  (gl:Enable gl:DEPTH_TEST)
  (gl:DepthFunc gl:LEQUAL)
  (gl:Enable gl:BLEND)
  (gl:BlendFunc gl:SRC_ALPHA gl:ONE_MINUS_SRC_ALPHA)
  (gl:Hint gl:PERSPECTIVE_CORRECTION_HINT gl:NICEST)
  (apply gl:ClearColor *clear-color*)
  (load-textures *texture-files* 'bmp))

(define (display)
  (pre-display-hook)
  (gl:Clear (+ gl:COLOR_BUFFER_BIT gl:DEPTH_BUFFER_BIT))
  (gl:MatrixMode gl:MODELVIEW)
  (gl:LoadIdentity)
  (let ((delta (- *last-frame* (current-milliseconds))))
    (game-loop delta))
  (gl:Flush)
  (glut:SwapBuffers)
  (set! *last-frame* (current-milliseconds))
  (post-display-hook))

(define (reshape width height)
  (pre-reshape-hook)
  (gl:Viewport 0 0 width height)
  (gl:MatrixMode gl:PROJECTION)
  (gl:LoadIdentity)
  (glu:Perspective 60.0 (/ width height) 1.0 300.0)
  (gl:MatrixMode gl:MODELVIEW)
  (gl:LoadIdentity)
  (post-reshape-hook))

(define (render-loop delta)
  (pre-render-hook)
  (glut:PostRedisplay)
  (handle-keyboard-state delta)
  (post-render-hook)
  (glut:TimerFunc 0 render-loop 0))

(define (main)
  (glut:InitDisplayMode (+ glut:DOUBLE glut:RGBA glut:DEPTH))
  (glut:InitWindowSize (nth *window-resolution* 0) (nth *window-resolution* 1))
  (glut:InitWindowPosition (nth *window-position* 0) (nth *window-position* 1))
  (glut:CreateWindow *window-title*)
  (init)
  (glut:DisplayFunc display)
  (glut:ReshapeFunc reshape)

  (glut:IgnoreKeyRepeat *ignore-key-repeat*)

  (glut:KeyboardFunc keyboard)
  (glut:KeyboardUpFunc keyboard-up)
  (glut:SpecialFunc keyboard)
  (glut:SpecialUpFunc keyboard-up)

  (glut:TimerFunc 1 render-loop 0)

  (pre-main-hook)
  (glut:MainLoop)
  (post-main-hook))

(main)
