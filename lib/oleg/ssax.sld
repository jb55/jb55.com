(define-library (oleg ssax)
  (export
   pre-post-order
   string->goodHTML
   entag
   enattr
   (rename ssax:read-char-data read-char-data)
   (rename ssax:make-parser make-parser)
   (rename ssax:make-pi-parser make-pi-parser)
   (rename ssax:make-elem-parser make-elem-parser)
   (rename ssax:xml->sxml xml->sxml)
   (rename SRV:send-reply send-reply)
   (rename SXML->HTML sxml->html))

  (import
   (scheme base)
   (scheme r5rs)
   (scheme write)
   (srfi 9)
   (oleg define-opt)
   (oleg input-parse))

  (begin
    (define myenv:error display))

  (include "input-parse/myenv-chibi.scm")
  ;; (include "ssax/ppretty-prints.scm") ;; For tests
  ;; (include "ssax/catch-error.scm") ;; For tests, also change import-immutable to import
  (include "input-parse/srfi-13-local.scm")
  (include "ssax/util.scm")
  (include "ssax/assert.scm")
  (include "input-parse/char-encoding.scm")
  (include "ssax/control.scm")
  (include "input-parse/parser-errors-vanilla.scm")
  (include "ssax/look-for-str.scm")
  (include "ssax/output.scm")
  (include "ssax/ssax-warn-vanilla.scm")
  (include "ssax/SSAX.scm")
  (include "ssax/SXML-tree-trans.scm")
  (include "ssax/SXML-to-HTML.scm"))
