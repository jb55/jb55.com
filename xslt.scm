
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
