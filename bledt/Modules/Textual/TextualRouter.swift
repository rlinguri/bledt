//
// File:      TextualRouter
// Module:    Textual
// Package:   bledt
//
// Author:    Roderic Linguri <rlinguri@mac.com>
// Copyright: © 2019 Roderic Linguri. All Rights Reserved.
// License:   MIT
//
// Requires:  > Swift 5.0 && > iOS 12.0
// Version:   0.2.3
// Since:     0.1.3
//

/// Handles navigation events for the module
class TextualRouter {
    
    // MARK: - Instance Properties
    
    /// Handles navigation events for the app
    let rootRouter: RootRouter
    
    // MARK: - Instance Methods
    
    /// Initialize a `TextualRouter` instance
    ///
    /// - Parameter rootRouter: Instance that handles navigation events for the app
    init(rootRouter: RootRouter) {
        self.rootRouter = rootRouter
    }
    
    // MARK: - Class Methods
    
    /// Factory method to assemble a the module's viewController
    ///
    /// - Parameter rootRouter: The `RootRouter`instance
    class func createViewController(rootRouter: RootRouter) -> UIViewController {
        let router = TextualRouter(rootRouter: rootRouter)
        let interactor = TextualInteractor(router: router)
        let presenter = TextualPresenter(interactor: interactor)
        return TextualViewController(presenter: presenter)
    }
    
}
