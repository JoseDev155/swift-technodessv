import Foundation

protocol GetNodesUseCaseProtocol {
    func execute() async throws -> [TechNode]
}

class GetNodesUseCase: GetNodesUseCaseProtocol {
    private let repository: NodeRepositoryProtocol
    
    init(repository: NodeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [TechNode] {
        return try await repository.fetchNodes()
    }
}
