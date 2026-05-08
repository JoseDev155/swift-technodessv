import Foundation

/// Entity representing a technology node (store, fab-lab, workshop).
struct TechNode: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
    let address: String
    let type: NodeType
    
    enum NodeType: String, Codable {
        case store
        case fabLab
        case workshop
    }
}
