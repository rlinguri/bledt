//
// File:      AppDelegate
// Module:    App
// Package:   bledt
//
// Author:    Roderic Linguri <rlinguri@mac.com>
// Copyright: © 2019 Roderic Linguri. All Rights Reserved.
// License:   MIT
//
// Requires:  > Swift 5.0 && > iOS 12.0
// Version:   0.2.3
// Since:     0.1.0
//

/// The Main Application Delegate
@UIApplicationMain
class AppDelegate: UIResponder {
    
    // MARK: - Properties

    /// The Application window
    var window: UIWindow?
    
    /// The Application router
    var router: RootRouter?
}

/// UIApplication Delegate
extension AppDelegate: UIApplicationDelegate {
    
    // MARK: - UIApplicationDelegate methods
    
    /// Override point for customization after application launch
    ///
    /// - Parameter application: The singleton app object
    /// - Parameter launchOptions: A dictionary indicating the reason the app was launched
    ///
    /// - Returns: A boolean indicating whether or not the app should be launched
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.router = RootRouter()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = self.window,
            let router = self.router {
            window.makeKeyAndVisible()
            window.rootViewController = router.navigationController
        }
        return true
    }
}
