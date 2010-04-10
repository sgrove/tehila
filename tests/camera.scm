(require-extension test)
(load "lib/gl_utils.scm")
(load "lib/camera.scm")

(test "Default camera velocity" (vertex 0 0 0) (current-camera-position))
(test "Default camera position" camera-position (current-camera-position))
(test "Default camera velocity" (vertex 0 0 0) (current-camera-position))
(test "Default camera position" camera-position (current-camera-position))

;; (test "Default camera angle" camera-position (vertex 0 0 0))
;; (test "Default camera " camera-position (vertex 0 0 0))
;; (test "Default camera position" camera-position (vertex 0 0 0))
;; (test "Default camera position" camera-position (vertex 0 0 0))



(exit)
