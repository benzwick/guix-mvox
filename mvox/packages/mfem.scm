(define-module (mvox packages mfem)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages compression))

(define-public mfem-4.5
  (package
    (name "mfem")
    (version "4.5.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mfem/mfem")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1hs2n278ggmq8gpvgsfgslh6lmx1mgdwywk31alfvdpj97d5nr5m"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list "-DCMAKE_CXX_FLAGS=-include cstdint"
              "-DBUILD_SHARED_LIBS=YES"
              "-DMFEM_USE_ZLIB=YES"
              "-DMFEM_USE_EXCEPTIONS=YES"
              "-DMFEM_ENABLE_TESTING=NO"
              "-DMFEM_ENABLE_EXAMPLES=NO"
              "-DMFEM_ENABLE_MINIAPPS=NO")
      #:tests? #f))
    (inputs (list zlib))
    (home-page "https://mfem.org")
    (synopsis "Finite element methods library")
    (description
     "MFEM is a modular parallel C++ library for finite element methods.
Its goal is to enable high-performance scalable finite element
discretization research and application development on a wide variety
of platforms, ranging from laptops to supercomputers.")
    (license license:bsd-3)))

(define-public mfem-4.9
  (package
    (inherit mfem-4.5)
    (version "4.9")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mfem/mfem")
             (commit (string-append "v" version))))
       (file-name (git-file-name "mfem" version))
       (sha256
        (base32 "0n3chkavzf0w0fdcj59s38kv3sbxsgg1g3ic4c458vkx24x83qfg"))))
    (arguments
     (list
      #:configure-flags
      #~(list "-DBUILD_SHARED_LIBS=YES"
              "-DMFEM_USE_ZLIB=YES"
              "-DMFEM_USE_EXCEPTIONS=YES"
              "-DMFEM_ENABLE_TESTING=NO"
              "-DMFEM_ENABLE_EXAMPLES=NO"
              "-DMFEM_ENABLE_MINIAPPS=NO")
      #:tests? #f))))

(define-public mfem mfem-4.9)
