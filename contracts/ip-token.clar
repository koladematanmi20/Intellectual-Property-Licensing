;; IP Token Contract

(define-non-fungible-token ip-token uint)

(define-data-var token-id-nonce uint u0)

(define-map token-metadata
  { token-id: uint }
  {
    owner: principal,
    ip-type: (string-ascii 20),
    name: (string-ascii 100),
    description: (string-ascii 500),
    creation-date: uint,
    expiration-date: uint
  }
)

(define-public (mint (ip-type (string-ascii 20)) (name (string-ascii 100)) (description (string-ascii 500)) (expiration-date uint))
  (let
    (
      (token-id (var-get token-id-nonce))
      (caller tx-sender)
    )
    (try! (nft-mint? ip-token token-id caller))
    (map-set token-metadata
      { token-id: token-id }
      {
        owner: caller,
        ip-type: ip-type,
        name: name,
        description: description,
        creation-date: block-height,
        expiration-date: expiration-date
      }
    )
    (var-set token-id-nonce (+ token-id u1))
    (ok token-id)
  )
)

(define-read-only (get-token-metadata (token-id uint))
  (map-get? token-metadata { token-id: token-id })
)

(define-public (transfer (token-id uint) (recipient principal))
  (let
    (
      (owner (unwrap! (nft-get-owner? ip-token token-id) (err u404)))
    )
    (asserts! (is-eq tx-sender owner) (err u403))
    (try! (nft-transfer? ip-token token-id tx-sender recipient))
    (ok true)
  )
)

