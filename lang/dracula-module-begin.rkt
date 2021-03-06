#lang racket

(require
  racket/require
  (path-up "self/require.rkt")
  "do-check.rkt"
  (teachpack-in testing)
  (teachpack-in doublecheck)
  (for-syntax
    "../proof/proof.rkt"
    "../proof/syntax.rkt"))

(provide dracula-module-begin)

(define-syntax (dracula-module-begin stx)
  (syntax-case stx ()
    [(_ . forms)
     (with-syntax ([exports (datum->syntax stx `(,#'all-defined-out))])
       (quasisyntax/loc stx
         (#%module-begin
          (define-values []
            #,(annotate-proof
               (make-proof
                (make-part
                 'Dracula
                 (syntax->loc stx)
                 (map syntax->term (syntax->list #'forms))))
               (syntax/loc stx (values))))
          (provide exports)
          (begin-below . forms)
          (generate-report!)
          (check-properties!))))]))
