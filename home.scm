(import (oleg ssax)
        (scheme base)
        (scheme file)
        (scheme write))

(include "misc.scm")
(include "xslt.scm")

; load from file?
(define posts
  '((post ((title "example post")
           (date "April 5, 2015")
           (body "This is an example post")))
    (post ((title "example post 2")
           (date "April 2, 2015")
           (link "/")
           (body
            "this is another post")))))

(define full-name "William Casarin")

(define data:website
  `(website
    (title "jb55.com")
    (repository "https://github.com/jb55/jb55.com")
    (description ,(<> full-name "'s site"))
    (contact
     (name ,full-name)
     (location "Vancouver, BC")
     (email "bill@casarin.me")
     (twitter "jb55")
     (github "jb55")
     (google-plus "WilliamCasarin"))
    (posts ,posts)))

(define template:post
  (template
   "post"
   `(article ,(@. "post")
             (h4 ,(@. "title") ,(value-of "title"))
             (div ,(@. "date") ,(value-of "date"))
             (div ,(@. "body") ,(value-of "body")))))


(define template:contact
  (template
   "contact"
   `(dl
     ,(dl-elem "Email" (make-link "mailto:" "email"))
     ,(dl-elem "GitHub" (make-link "https://github.com/" "github"))
     ,(dl-elem "Twitter" (make-link "https://twitter.com/" "twitter"))
     ,(dl-elem "Google+" (make-link "https://google.com/+" "google-plus"))
     )))

(define template:posts
  (template
   "posts"
   `((h3 "Posts")
     (section ,(@. "posts")
              ,(apply-templates "post")))))

(define template:page
  (template
   "/website"
   `(html
     (head
      (title ,(value-of "title"))
      (description ,(value-of "description")))
     (body
      (h2 ,(value-of "description"))
      (section ,(@. "contact")
       (h3 "Contact")
       ,(apply-templates "contact"))
      ,(apply-templates "posts")))))

(define my-xsl
  (stylesheet `(,template:contact
                ,template:page
                ,template:posts
                ,template:post)))

(define (build-page stylesheet-uri xml)
  `(,xml-header
    (*?* xml-stylesheet (@ (type "text/xsl")
                           (href ,stylesheet-uri)))
    ,xml))

(begin
  (let* ((xsl-uri "style.xsl")
         (page (sxml->xml (build-page xsl-uri data:website)))
         (xsl-page (sxml->xml my-xsl)))
    (call-with-output-file xsl-uri
      (lambda (out)
        (send-reply out xsl-page)))
    (send-reply (current-output-port) page)))
