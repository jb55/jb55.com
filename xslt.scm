
;; XSLT helpers
(define (value-of path)
  `(xsl:value-of
    (@ (select ,path))
    ()))

(define (apply-templates name)
  `(xsl:apply-templates
    (@ (select ,name))
    ()))

(define (template name body)
  `(xsl:template (@ (match ,name)) ,body))

(define (stylesheet contents)
  `(,xml-header
    (xsl:stylesheet (@ (version "1.0")
                       (xmlns:xsl "http://www.w3.org/1999/XSL/Transform"))
                    ,contents)))
