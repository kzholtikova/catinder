import Foundation
import UIKit
import Combine

final class Coordinator {
    let rootViewController: UINavigationController
    private let window: UIWindow
    private let catAPIService: CatAPIService
    
    init(rootViewController: UINavigationController, window: UIWindow, APIservice: CatAPIService) {
        self.rootViewController = rootViewController
        self.window = window
        self.catAPIService = APIservice
    }
    
    func start() {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = .gray
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        
        let catBreedsVC = CatBreedsViewController(viewModel: CatBreedsViewModel(catAPIService: catAPIService))
        catBreedsVC.tabBarItem = UITabBarItem(title: "Breeds", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        tabBarController.viewControllers = [catBreedsVC]
        rootViewController.pushViewController(tabBarController, animated: false)
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
