import Foundation
import Combine

@MainActor
class InventoryViewModel {
    
    enum State {
        case idle
        case loading
        case success([Component])
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    
    private let getInventoryUseCase: GetInventoryUseCaseProtocol
    private let saveComponentUseCase: SaveComponentUseCaseProtocol
    private let deleteComponentUseCase: DeleteComponentUseCaseProtocol
    
    init(getInventoryUseCase: GetInventoryUseCaseProtocol,
         saveComponentUseCase: SaveComponentUseCaseProtocol,
         deleteComponentUseCase: DeleteComponentUseCaseProtocol) {
        self.getInventoryUseCase = getInventoryUseCase
        self.saveComponentUseCase = saveComponentUseCase
        self.deleteComponentUseCase = deleteComponentUseCase
    }
    
    func loadInventory() {
        state = .loading
        Task {
            do {
                let components = try await getInventoryUseCase.execute()
                state = .success(components)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func addComponent(name: String, quantity: Int) {
        let newComponent = Component(id: UUID().uuidString, name: name, quantity: quantity, isPurchased: false, expectedPrice: nil)
        Task {
            do {
                try await saveComponentUseCase.execute(component: newComponent)
                loadInventory() // Reload to reflect changes
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func deleteComponent(id: String) {
        Task {
            do {
                try await deleteComponentUseCase.execute(id: id)
                loadInventory()
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
