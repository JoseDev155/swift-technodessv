import Foundation

protocol GetInventoryUseCaseProtocol {
    func execute() async throws -> [Component]
}

class GetInventoryUseCase: GetInventoryUseCaseProtocol {
    private let repository: InventoryRepositoryProtocol
    
    init(repository: InventoryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Component] {
        return try await repository.getComponents()
    }
}

protocol SaveComponentUseCaseProtocol {
    func execute(component: Component) async throws
}

class SaveComponentUseCase: SaveComponentUseCaseProtocol {
    private let repository: InventoryRepositoryProtocol
    
    init(repository: InventoryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(component: Component) async throws {
        try await repository.saveComponent(component)
    }
}

protocol DeleteComponentUseCaseProtocol {
    func execute(id: String) async throws
}

class DeleteComponentUseCase: DeleteComponentUseCaseProtocol {
    private let repository: InventoryRepositoryProtocol
    
    init(repository: InventoryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: String) async throws {
        try await repository.deleteComponent(id: id)
    }
}
