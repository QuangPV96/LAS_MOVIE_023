
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var newVC: UINavigationController?
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupVC()
        return true
    }

    func setupVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc: HomeVC = HomeVC()
        newVC = UINavigationController(rootViewController: vc)
        newVC?.isNavigationBarHidden = true
        window?.rootViewController = newVC
        window?.makeKeyAndVisible()
    }
}
