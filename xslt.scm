
;; XSLT helpers
(define (value-of path)
  `(xsl:value-of
    (@ (select ,path))
    ()))

(define (attribute attr contents)
  `(xsl:attribute
    (@ (name ,attr))
    ,contents))

(define (apply-templates name)
  `(xsl:apply-templates
    (@ (select ,name))
    ()))

(define (call-template name)
  `(xsl:call-template
    (@ (select ,name))
    ()))

(define (template name body)
  `(xsl:template (@ (match ,name)) ,body))

(define (stylesheet contents)
  `(,xml-header
    (xsl:stylesheet (@ (version "1.0")
                       (xmlns:xsl "http://www.w3.org/1999/XSL/Transform"))
                    ,contents)))
