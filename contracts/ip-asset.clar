;; IP Asset Management Contract

(define-non-fungible-token ip-asset uint)

(define-map ip-assets
  uint
  {
    owner: principal,
    asset-type: (string-ascii 20),
    metadata: (string-utf8 500),
    fractions: uint
  }
)

(define-data-var asset-id-nonce uint u0)

(define-public (mint-ip-asset (asset-type (string-ascii 20)) (metadata (string-utf8 500)) (fractions uint))
  (let
    ((asset-id (+ (var-get asset-id-nonce) u1))
     (ip-asset-data {
       owner: tx-sender,
       asset-type: asset-type,
       metadata: metadata,
       fractions: fractions
     }))
    (try! (nft-mint? ip-asset asset-id tx-sender))
    (map-set ip-assets asset-id ip-asset-data)
    (var-set asset-id-nonce asset-id)
    (ok asset-id)
  )
)

(define-read-only (get-ip-asset (asset-id uint))
  (ok (unwrap! (map-get? ip-assets asset-id) (err u404)))
)

(define-public (transfer-ip-asset (asset-id uint) (recipient principal))
  (let
    ((asset (unwrap! (map-get? ip-assets asset-id) (err u404))))
    (asserts! (is-eq tx-sender (get owner asset)) (err u403))
    (try! (nft-transfer? ip-asset asset-id tx-sender recipient))
    (ok (map-set ip-assets asset-id (merge asset { owner: recipient })))
  )
)

