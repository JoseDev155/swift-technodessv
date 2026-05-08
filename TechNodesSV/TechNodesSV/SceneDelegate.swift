//
//  SceneDelegate.swift
//  TechNodesSV
//
//  Created by ESTUDIANTE on 7/5/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // Setup Shared Dependencies
        let networkService = NetworkService()
        let nodeRepository = NodeRepository(networkService: networkService)
        let getNodesUseCase = GetNodesUseCase(repository: nodeRepository)

        // Setup View Controllers
        let locationService = LocationService()
        let mapViewModel = MapViewModel(getNodesUseCase: getNodesUseCase, locationService: locationService)
        let mapVC = MapViewController(viewModel: mapViewModel)
        let mapNav = UINavigationController(rootViewController: mapVC)
        mapNav.tabBarItem = UITabBarItem(title: "tab_map".localized, image: UIImage(systemName: "map"), tag: 0)
        
        // Setup Dependencies for Directory
        let directoryViewModel = DirectoryViewModel(getNodesUseCase: getNodesUseCase)
        
        let directoryVC = DirectoryViewController(viewModel: directoryViewModel)
        let directoryNav = UINavigationController(rootViewController: directoryVC)
        directoryNav.tabBarItem = UITabBarItem(title: "tab_directory".localized, image: UIImage(systemName: "list.bullet"), tag: 1)
        
        // Setup Dependencies for Inventory
        let inventoryRepository = InventoryRepository()
        let getInventoryUseCase = GetInventoryUseCase(repository: inventoryRepository)
        let saveComponentUseCase = SaveComponentUseCase(repository: inventoryRepository)
        let deleteComponentUseCase = DeleteComponentUseCase(repository: inventoryRepository)
        let inventoryViewModel = InventoryViewModel(getInventoryUseCase: getInventoryUseCase, saveComponentUseCase: saveComponentUseCase, deleteComponentUseCase: deleteComponentUseCase)
        
        let inventoryVC = InventoryViewController(viewModel: inventoryViewModel)
        let inventoryNav = UINavigationController(rootViewController: inventoryVC)
        inventoryNav.tabBarItem = UITabBarItem(title: "tab_inventory".localized, image: UIImage(systemName: "archivebox"), tag: 2)
        
        // Setup TabBar
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mapNav, directoryNav, inventoryNav]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

