import Foundation

protocol InventoryRepositoryProtocol {
    func getComponents() async throws -> [Component]
    func saveComponent(_ component: Component) async throws
    func deleteComponent(id: String) async throws
}
