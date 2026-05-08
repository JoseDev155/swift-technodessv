import Foundation

class NodeRepository: NodeRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchNodes() async throws -> [TechNode] {
        return try await networkService.fetchNodes()
    }
}
