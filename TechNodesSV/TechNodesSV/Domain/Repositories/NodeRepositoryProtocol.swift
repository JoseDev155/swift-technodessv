import Foundation

protocol NodeRepositoryProtocol {
    func fetchNodes() async throws -> [TechNode]
}
