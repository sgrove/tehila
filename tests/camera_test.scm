(require-extension test)
(load "lib/math_utils.scm")
(load "lib/list_utils.scm")
(load "lib/gl_utils.scm")
(load "lib/camera.scm")

(parameterize ((current-test-epsilon 1e-0))
  
  (test-begin "Camera system")
  (test-begin "Default camera global variables")
  
  (test "Default (current-camera-position)"
        (vertex 0.0 0.0 0.0)
        (current-camera-position))

  (test "Default camera position"
        camera-position
        (current-camera-position))

  (test "Default (current-camera-angle)"
        (vertex 0.0 0.0 0.0)
        (current-camera-angle))

  (test "Default camera angle"
        camera-angle
        (current-camera-angle))
  
  (test-end)
  (test-begin "Camera movement")

  (test "Move camera on x-axis"
        (vertex 5.0 0.0 0.0)
        (begin
          (move-camera (vertex 5 0 0))
          (update-camera 1)
          (current-camera-position)))
  (reset-camera)

  (test "Move camera on y-axis"
        (vertex 0.0 5.0 0.0)
        (begin
          (move-camera (vertex 0 5 0))
          (update-camera 1)
          (current-camera-position)))
  (reset-camera)

  (test "Move camera on z-axis"
        (vertex 0.0 0.0 5.0)
        (begin
          (move-camera (vertex 0 0 5))
          (update-camera 1)
          (current-camera-position)))
  (reset-camera)

  (test "Move camera on all axis"
        (vertex 5.0 5.0 5.0)
        (begin
          (move-camera (vertex 5 5 5))
          (update-camera 1)
          (current-camera-position)))

  (reset-camera)
  (test "Turn 0 degrees, move camera forward 2"
        (vertex 0.0 0.0 -2.0)
        (vertex-truncate (begin
                           (move-camera-forward 2)
                           (update-camera 1)
                           (current-camera-position))))

  (reset-camera)
  (test "Turn 45 degrees, move forward 2"
        (vertex 1.41 0.0 -1.41)
        (vertex-truncate (begin
                           (turn-camera (vertex 0 45 0))
                           (update-camera 1)
                           (move-camera-forward 2)
                           (update-camera 1)
                           (current-camera-position))))

  (reset-camera)
  (test "Turn 65 degrees, move forward 3"
        (vertex 2.72 0.0 -1.27)
        (vertex-truncate (begin
                           (turn-camera (vertex 0 65 0))
                           (update-camera 1)
                           (move-camera-forward 3)
                           (update-camera 1)
                           (current-camera-position))))

  (reset-camera)

  (test "Turn -65 degrees, move forward 4"
        (vertex -3.63 0.0 -1.69)
        (vertex-truncate (begin
                           (turn-camera (vertex 0 -65 0))
                           (update-camera 1)
                           (move-camera-forward 4)
                           (update-camera 1)
                           (current-camera-position))))

  (reset-camera)
  (test "Turn -65 degrees, move forward 4, turn 20, move forward 5"
        (vertex -7.16 0.0 -5.23)
        (vertex-truncate (begin
                           (turn-camera (vertex 0 -65 0))
                           (update-camera 1)
                           (move-camera-forward 4)
                           (update-camera 1)
                           (turn-camera (vertex 0 20 0))
                           (update-camera 1)
                           (move-camera-forward 5)
                           (update-camera 1)
                           (current-camera-position))))

  (reset-camera)
  (test "Turn 0 degrees, strafe left 5"
        (vertex -5.0 0.0 0.0)
        (vertex-truncate (begin
                           (strafe-camera (vertex -5 0 0))
                           (update-camera 1)
                           (current-camera-position))))

  (reset-camera)
  (test "Turn 0 degrees, strafe right 5"
        (vertex 5.0 0.0 0.0)
        (vertex-truncate (begin
                           (strafe-camera (vertex 5 0 0))
                           (update-camera 1)
                           (current-camera-position))))

  (reset-camera)
  (test "Turn 16 degrees, strafe left 10"
        (vertex -9.61 0.0 2.76)
        (vertex-truncate (begin
                           (turn-camera (vertex 0 16 0))
                           (update-camera 1)
                           (strafe-camera (vertex -10 0 0))
                           (update-camera 1)
                           (current-camera-position))))
  
  (test-end)

  (test-begin "Camera rotation")
  (reset-camera)
  (test "Rotate camera about x-axis"
        (vertex 5.0 0.0 0.0)
        (begin
          (turn-camera (vertex 5 0 0))
          (update-camera 1)
          (current-camera-angle)))
  (reset-camera)

  (test "Rotate camera about y-axis"
        (vertex 0.0 5.0 0.0)
        (begin
          (turn-camera (vertex 0 5 0))
          (update-camera 1)
          (current-camera-angle)))

  (reset-camera)
  (test "Rotate camera about z-axis"
        (vertex 0.0 0.0 5.0)
        (begin
          (turn-camera (vertex 0 0 5))
          (update-camera 1)
          (current-camera-angle)))

  (reset-camera)
  (test "Rotate camera about all axis"
        (vertex 5.0 5.0 5.0)
        (begin
          (turn-camera (vertex 5 5 5))
          (update-camera 1)
          (current-camera-angle)))
  (reset-camera)
  (test-end)


  (test-begin "Camera orbiting")
  (reset-camera)
  (test "From origin, turn 50 degrees, (get-orbit-center 10)"
        (vertex 7.66 0.0 -6.43)
        (vertex-truncate (begin
                           (turn-camera (vertex 0 50 0))
                           (update-camera 1)
                           (get-orbit-center 10))))

  (reset-camera)
  (test "From origin, turn 70 degrees, walk-forward 5, turn 20 degrees (get-orbit-center 10)"
        (vertex 14.7 0.0 -1.71)
        (vertex-truncate (begin
                           (turn-camera (vertex 0 70 0))
                           (update-camera 1)
                           (move-camera-forward 5)
                           (update-camera 1)
                           (turn-camera (vertex 0 20 0))
                           (update-camera 1)
                           (get-orbit-center 10))))
  (reset-camera)
  (test-end)
  (test-end))

(exit)
