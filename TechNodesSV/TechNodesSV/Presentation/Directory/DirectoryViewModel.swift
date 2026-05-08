import Foundation

@MainActor
class DirectoryViewModel {
    
    enum State {
        case idle
        case loading
        case success([TechNode])
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    private let getNodesUseCase: GetNodesUseCaseProtocol
    
    init(getNodesUseCase: GetNodesUseCaseProtocol) {
        self.getNodesUseCase = getNodesUseCase
    }
    
    func fetchNodes() {
        state = .loading
        Task {
            do {
                let nodes = try await getNodesUseCase.execute()
                state = .success(nodes)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
