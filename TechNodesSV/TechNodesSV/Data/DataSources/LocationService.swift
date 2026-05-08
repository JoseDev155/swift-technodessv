import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func requestPermission()
    var locationUpdateHandler: ((CLLocation?) -> Void)? { get set }
    var permissionDeniedHandler: (() -> Void)? { get set }
}

@Observable
final class LocationService: NSObject, LocationServiceProtocol, @unchecked Sendable {
    private let locationManager = CLLocationManager()
    private var updateTask: Task<Void, Never>?
    
    var locationUpdateHandler: ((CLLocation?) -> Void)?
    var permissionDeniedHandler: (() -> Void)?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            // Need a brief delegate just to catch the response of requestWhenInUseAuthorization
            // in iOS 17 before jumping to the stream, or we can just start the stream and it will prompt.
            // Modern CoreLocation liveUpdates() actually prompts automatically when iterated!
            startTracking()
        case .authorizedWhenInUse, .authorizedAlways:
            startTracking()
        case .denied, .restricted:
            permissionDeniedHandler?()
        @unknown default:
            break
        }
    }
    
    private func startTracking() {
        updateTask?.cancel()
        updateTask = Task {
            do {
                // MapKit skill: Modern CLLocationUpdate.liveUpdates() async stream
                let updates = CLLocationUpdate.liveUpdates()
                for try await update in updates {
                    guard let location = update.location else { continue }
                    // Filter by horizontal accuracy
                    guard location.horizontalAccuracy < 500 else { continue }
                    
                    self.locationUpdateHandler?(location)
                    
                    // Stop tracking once we get a good fix for the map
                    stopTracking()
                    break
                }
            } catch {
                // Handle stream errors (like permissions denied during stream)
                self.permissionDeniedHandler?()
            }
        }
    }
    
    private func stopTracking() {
        updateTask?.cancel()
        updateTask = nil
    }
}
