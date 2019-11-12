//
// File:      GraphicInteractor
// Module:    Graphic
// Package:   bledt
//
// Author:    Roderic Linguri <rlinguri@mac.com>
// Copyright: © 2019 Roderic Linguri. All Rights Reserved.
// License:   MIT
//
// Requires:  > Swift 5.0 && > iOS 12.0
// Version:   0.2.3
// Since:     0.2.0
//

/// Protocol to receive messages from the interactor
protocol GraphicInteractorDelegate: class {

    /// Called when the interactor has retrieved data
    func interactorDidRetrieveData(coordinates: [Coordinate])

}

/// Handles the module's network and storage tasks
class GraphicInteractor {

    // MARK: - Instance Properties
    
    /// Handles navigation events for the module
    let router: GraphicRouter
    
    /// An instance that will receive messages from the interactor
    weak var delegate: GraphicInteractorDelegate?

    /// The instance that interfaces our data
    var dataManager: DataManager!

    // MARK: - Instance Methods
    
    /// Initialize the `GraphicInteractor` instance
    ///
    /// - Parameter router: The instance that handles navigation
    init(router: GraphicRouter) {
        self.router = router
        self.dataManager = DataManager(
            storage: Storage(),
            network: Network()
        )
        self.dataManager.delegate = self
    }
    
}

extension GraphicInteractor: DataManagerDelegate {

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
        
        var coordinates: [Coordinate] = []
        
       for batch in batchManager.batches {
            let coordinate = Coordinate(
                milliseconds: batch.seq * 240,
                samples: batch.data.count
            )
            coordinates.append(coordinate)
        }
        self.delegate?.interactorDidRetrieveData(coordinates: coordinates)
    }
    
    /// Called when the DataManager encounters an error
    /// - Parameter error: Swift Error
    func didProduceError(error: Error) {
        self.router.rootRouter.displayAlert(
            origin: self.dataManager,
            message: error.localizedDescription,
            withRetry: true
        )
        
    }

}
