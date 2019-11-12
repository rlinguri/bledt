//
// File:      TextualInteractor
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

/// Protocol to receive messages from the interactor
protocol TextualInteractorDelegate: class {

    /// Called when the interactor has retrieved data
    func interactorDidRetrieveData(
        batchCount: Int,
        completebatchCount: Int,
        sampleCount: Int,
        missingSampleCount: Int
    )

    /// Called when the interactor has retrieved data
    func interactorDidProduceError(message: String)

}

/// Handles the module's network and storage tasks
class TextualInteractor {

    // MARK: - Instance Properties
    
    /// Handles navigation events for the module
    let router: TextualRouter
    
    /// An instance that will receive messages from the interactor
    weak var delegate: TextualInteractorDelegate?
    
    /// The instance that interfaces our data
    var dataManager: DataManager!
    
    // MARK: - Instance Methods
    
    /// Initialize the `TextualInteractor` instance
    ///
    /// - Parameter router: The instance that handles navigation
    init(router: TextualRouter) {
        self.router = router
        self.dataManager = DataManager(
            storage: Storage(),
            network: Network()
        )
        self.dataManager.delegate = self
    }
    
}

extension TextualInteractor: DataManagerDelegate {
    
    /// Called when the DataManager instance has retrieved data
    ///
    /// - Parameter data: the samples as data
    func didRetrieveData(data: Data) {
        
        var completeBatchCount: Int = 0
        var missingSampleCount: Int = 0
        
        let batchManager = BatchManager(data: data)
        for batch in batchManager.batches {
            if batch.isComplete {
                completeBatchCount += 1
            } else {
                missingSampleCount += (16 - batch.data.count)
            }
        }
        
        self.delegate?.interactorDidRetrieveData(
            batchCount: batchManager.batches.count,
            completebatchCount: completeBatchCount,
            sampleCount: batchManager.samples.count,
            missingSampleCount: missingSampleCount
        )
    }
    
    /// Called when the DataManager encounters an error
    /// - Parameter error: Swift Error
    func didProduceError(error: Error) {
        self.router.rootRouter.displayAlert(origin: self.dataManager, message: error.localizedDescription, withRetry: true)
        self.delegate?.interactorDidProduceError(message: error.localizedDescription)
    }
    
}
