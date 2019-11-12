//
// File:      RootRouter
// Module:    App
// Package:   bledt
//
// Author:    Roderic Linguri <rlinguri@mac.com>
// Copyright: © 2019 Roderic Linguri. All Rights Reserved.
// License:   MIT
//
// Requires:  > Swift 5.0 && > iOS 12.0
// Version:   0.2.3
// Since:     0.1.2
//

/// Handles app navigation
class RootRouter {
    
    // MARK: - Properties

    /// The top level view of the application
    var navigationController: UINavigationController!
    
    /// An optional alert being displayed
    var alert: UIAlertController?
    
    // MARK: - Instance Methods

    /// Initialize the `RootRouter` instance
    init() {
        let rootViewController = TextualRouter.createViewController(rootRouter: self)
        self.navigationController = UINavigationController(rootViewController: rootViewController)
    }
    
    /// Push the graphic view ontothe stack
    func showGraph() {
        let graphViewController = GraphicRouter.createViewController(rootRouter: self)
        self.navigationController?.pushViewController(graphViewController, animated: true)
    }
    
    /// Display an alert from the Data manager
    ///
    /// - Parameter origin: The class that
    /// - Parameter message: The message to display in the alert
    /// - Parameter withRetry: Should the origin re-attempt execution?
    func displayAlert(origin: Any?, message: String, withRetry: Bool) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { [weak self] _ in
            self?.navigationController.dismiss(animated: true, completion: nil)
        }

        alert.addAction(cancelAction)

        if withRetry {
            let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                if let dataManager = origin as? DataManager {
                    self?.navigationController.dismiss(animated: true, completion: dataManager.fetch)
                } else {
                    self?.navigationController.present(alert, animated: true, completion: nil)
                }
            }
            alert.addAction(retryAction)
        }

        self.navigationController.present(alert, animated: true, completion: nil)
    }
    
}
