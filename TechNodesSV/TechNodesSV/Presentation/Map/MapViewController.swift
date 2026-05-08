import UIKit
import MapKit
import Combine

class MapViewController: UIViewController {
    
    private let viewModel: MapViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        return map
    }()
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "tab_map".localized
        
        setupUI()
        bindViewModel()
        viewModel.loadDataAndRequestLocation()
    }
    
    private func setupUI() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: MapViewModel.State) {
        switch state {
        case .idle, .loading:
            break
        case .nodesLoaded(let nodes):
            addAnnotations(for: nodes)
        case .userLocationUpdated(let location):
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)
        case .locationPermissionDenied:
            showErrorAlert(message: "Location permission denied. Map will not center on your location.")
        case .error(let message):
            showErrorAlert(message: message)
        }
    }
    
    private func addAnnotations(for nodes: [TechNode]) {
        mapView.removeAnnotations(mapView.annotations) // Clear old ones
        
        for node in nodes {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: node.latitude, longitude: node.longitude)
            annotation.title = node.name
            annotation.subtitle = node.description
            mapView.addAnnotation(annotation)
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "error".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default))
        present(alert, animated: true)
    }
}
