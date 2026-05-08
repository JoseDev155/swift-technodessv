import UIKit
import Combine

class InventoryViewController: UIViewController {
    
    private let viewModel: InventoryViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "ComponentCell")
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private var components: [Component] = []
    
    init(viewModel: InventoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "tab_inventory".localized
        
        setupUI()
        bindViewModel()
        viewModel.loadInventory()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: InventoryViewModel.State) {
        switch state {
        case .idle, .loading:
            break // Handled simply for now
        case .success(let components):
            self.components = components
            tableView.reloadData()
        case .error(let message):
            showErrorAlert(message: message)
        }
    }
    
    @objc private func addButtonTapped() {
        let alert = UIAlertController(title: "Add Component", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Quantity"
            textField.keyboardType = .numberPad
        }
        
        let addAction = UIAlertAction(title: "save".localized, style: .default) { [weak self, weak alert] _ in
            guard let name = alert?.textFields?[0].text, !name.isEmpty,
                  let qtyString = alert?.textFields?[1].text, let qty = Int(qtyString) else { return }
            self?.viewModel.addComponent(name: name, quantity: qty)
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "error".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default))
        present(alert, animated: true)
    }
}

extension InventoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComponentCell", for: indexPath)
        let component = components[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = component.name
        content.secondaryText = "Qty: \(component.quantity)"
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let component = components[indexPath.row]
            viewModel.deleteComponent(id: component.id)
        }
    }
}
