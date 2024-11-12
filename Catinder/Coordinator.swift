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
        UITabBar.appearance().barTintColor = .gray
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .white
        UITabBar.appearance().isTranslucent = false
        
        let tabBarController = UITabBarController()
        
        let randomCatVM = RandomCatViewModel(catAPIService: catAPIService)
        let randomCatVC = RandomCatViewController(viewModel: randomCatVM)
        randomCatVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let catBreedsVM = CatBreedsViewModel(catAPIService: catAPIService)
        let catBreedsVC = CatBreedsViewController(viewModel: catBreedsVM)
        catBreedsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        tabBarController.viewControllers = [randomCatVC, catBreedsVC]
        rootViewController.pushViewController(tabBarController, animated: false)
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
