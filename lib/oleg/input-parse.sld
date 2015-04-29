(define-library (oleg input-parse)
  (export
   peek-next-char assert-curr-char skip-until skip-while
   next-token next-token-of read-text-line read-string)
  (import-immutable (scheme base)
                    (oleg define-opt)
                    ;; TODO: remove (chibi io) ?
                    (only (chibi io) read-string))
  (include "input-parse/myenv-chibi.scm")
  (include "input-parse/char-encoding.scm")
  (include "input-parse/srfi-13-local.scm")
  (include "input-parse/parser-errors-vanilla.scm")
  (include "input-parse/input-parse.scm"))
