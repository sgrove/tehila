(require-extension srfi-1)

; TODO: Keeping this sorted may be a good idea for performance
(define *keyboard-state* (list))

(define (kb:add-key key)
  (print "Adding a key!")
  (set! *keyboard-state* (append *keyboard-state* (list key))))
  ;(kb:debug-keyboard-state))

(define (kb:remove-key key)
  (print "Removing a key!")
  (when (member key *keyboard-state*)
    (set! *keyboard-state* (remove (lambda (x) (equal? x key)) *keyboard-state*)))
    (kb:debug-keyboard-state))

(define (kb:key-pressed? key)
  (member key *keyboard-state*))

(define (kb:debug-keyboard-state)
  (print (->string *keyboard-state*)))

(define (keyboard key x y)
  (kb:add-key key))

(define (keyboard-up key x y)
  (kb:remove-key key))

