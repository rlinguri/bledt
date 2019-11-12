//
// File:      GraphicPresenter
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

/// Protocol to receive messages from the presenter
protocol GraphicPresenterDelegate: class {

    /// Called when the presenter's data or state have changed
    func presenterDidUpdate()

}

/// Handles data to be displayed by the view
class GraphicPresenter {
    
    // MARK: - Instance Properties
    
    /// The instance that handles the module's data and storage tasks
    let interactor: GraphicInteractor
    
    /// A flag to indicate whether or not we have data ready for the view
    var isLoading: Bool
    
    /// The coordinates to use for the graph
    var coordinates: [Coordinate]
    
    /// How wide to draw the graph
    var graphwidth: CGFloat = 4488
    
    /// The instance that will receive messages from the presenter
    weak var delegate: GraphicPresenterDelegate?
    
    // MARK: - Instance Methods
    
    /// Initialize the `GraphicPresenter` instance
    ///
    /// - Parameter interactor: The instance that handles the module's data and storage tasks
    init(interactor: GraphicInteractor) {
        self.isLoading = true
        self.interactor = interactor
        self.coordinates = []
        self.interactor.delegate = self
    }
    
}

/// GraphicInteractorDelegate
extension GraphicPresenter: GraphicInteractorDelegate {
    
    /// Called when the interactor has retrieved data
    func interactorDidRetrieveData(coordinates: [Coordinate]) {
        // Prepare/format data for presentation
        self.coordinates = coordinates
        if let lastCoordinate = coordinates.last {
            self.graphwidth = CGFloat(lastCoordinate.milliseconds) * 0.02
        }
        self.delegate?.presenterDidUpdate()
    }
    
}
