import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationContoller = UINavigationController()
        let window = UIWindow(windowScene: windowScene)
        let catAPIservice = CatAPIService()
        
        coordinator = Coordinator(rootViewController: navigationContoller, window: window, APIservice: catAPIservice)
        coordinator?.start()
    }
}
