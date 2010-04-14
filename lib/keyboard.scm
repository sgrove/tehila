(require-extension srfi-1)

; TODO: Keeping this sorted may be a good idea for performance
(define *keyboard-state* (list))

(define (kb:add-key key)
  (set! *keyboard-state* (append *keyboard-state* (list key)))
  (kb:debug-keyboard-state))

(define (kb:remove-key key)
  (when (member key *keyboard-state*)
    (set! *keyboard-state* (remove (lambda (x) (equal? x key)) *keyboard-state*)))
    (kb:debug-keyboard-state))

(define (kb:key-pressed? key)
  (member key *keyboard-state*))

(define (kb:debug-keyboard-state #!optional output-function)
  (let ((f (or output-function *default-debug-function* print)))
    (f (string-append "*keyboard-state*: "(->string *keyboard-state*)))))

(define (keyboard key x y)
  (kb:add-key key))

(define (keyboard-up key x y)
  (kb:remove-key key))


(define kb:LEFT 100)
(define kb:RIGHT 102)
(define kb:UP 101)
(define kb:DOWN 103)
