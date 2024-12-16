
struct PurchaseData: Codable, Sendable {
    let redirectLink: String
    let purchaseId: Int
    let orderReference: String

    // Custom coding keys for JSON keys with underscores
    enum CodingKeys: String, CodingKey {
        case redirectLink = "redirect_link"
        case purchaseId = "purchase_id"
        case orderReference = "order_reference"
    }
}
