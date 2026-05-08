import Foundation

/// Entity representing an electronic component in the user's inventory or wish list.
struct Component: Identifiable {
    let id: String
    var name: String
    var quantity: Int
    var isPurchased: Bool
    var expectedPrice: Double? // In USD
}
