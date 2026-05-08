import Foundation
import CoreLocation

@MainActor
class MapViewModel {
    
    enum State {
        case idle
        case loading
        case nodesLoaded([TechNode])
        case userLocationUpdated(CLLocation)
        case locationPermissionDenied
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    
    private let getNodesUseCase: GetNodesUseCaseProtocol
    private var locationService: LocationServiceProtocol
    
    init(getNodesUseCase: GetNodesUseCaseProtocol, locationService: LocationServiceProtocol) {
        self.getNodesUseCase = getNodesUseCase
        self.locationService = locationService
        
        setupLocationService()
    }
    
    private func setupLocationService() {
        self.locationService.locationUpdateHandler = { [weak self] location in
            guard let location = location else { return }
            DispatchQueue.main.async {
                self?.state = .userLocationUpdated(location)
            }
        }
        
        self.locationService.permissionDeniedHandler = { [weak self] in
            DispatchQueue.main.async {
                self?.state = .locationPermissionDenied
            }
        }
    }
    
    func loadDataAndRequestLocation() {
        state = .loading
        
        // Fetch nodes
        Task {
            do {
                let nodes = try await getNodesUseCase.execute()
                state = .nodesLoaded(nodes)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
        
        // Request location
        locationService.requestPermission()
    }
}
