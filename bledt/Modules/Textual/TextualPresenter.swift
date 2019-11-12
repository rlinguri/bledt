//
// File:      TextualPresenter
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

/// Protocol to receive messages from the presenter
protocol TextualPresenterDelegate: class {
    
    /// Called when the presenter's data or state have changed
    func presenterDidUpdate()
    
}

/// Handles data to be displayed by the view
class TextualPresenter {
    
    // MARK: - Instance Properties
    
    /// The instance that handles the module's data and storage tasks
    let interactor: TextualInteractor
    
    /// A flag to indicate whether or not we have data ready for the view
    var isLoading: Bool
    
    /// The instance that will receive messages from the presenter
    weak var delegate: TextualPresenterDelegate?
    
    /// The text to display to the user
    var text: String?
    
    // MARK: - Instance Methods
    
    /// Initialize the `TextualPresenter` instance
    ///
    /// - Parameter interactor: The instance that handles the module's data and storage tasks
    init(interactor: TextualInteractor) {
        self.isLoading = true
        self.interactor = interactor
        self.interactor.delegate = self
    }
    
}

/// TextualInteractorDelegate
extension TextualPresenter: TextualInteractorDelegate {
    
    /// Called when the interactor has parsed data
    ///
    /// - Parameter batchCount: number of batches
    /// - Parameter completebatchCount: number of complete batches
    /// - Parameter sampleCount: number of samples
    /// - Parameter missingSampleCount: number of missing samples
    func interactorDidRetrieveData(
        batchCount: Int,
        completebatchCount: Int,
        sampleCount: Int,
        missingSampleCount: Int
    ) {
        
        let padSampleCount = String(sampleCount).leftPadding(toLength: 5, withPad: " ")
        let padMissingSamples = String(missingSampleCount).leftPadding(toLength: 5, withPad: " ")
        let padBatchCount = String(batchCount).leftPadding(toLength: 5, withPad: " ")
        let padCompleteBatches = String(completebatchCount).leftPadding(toLength: 5, withPad: " ")

        self.isLoading = false
        self.text = """
        Count of Samples: \(padSampleCount)\n
        Missing Samples : \(padMissingSamples)\n
        Count of Batches: \(padBatchCount)\n
        Complete Batches: \(padCompleteBatches)\n
        """
        self.delegate?.presenterDidUpdate()
    }
    
    /// Called when the interactor has encountered an error
    func interactorDidProduceError(message: String) {
        self.isLoading = false
        self.text = nil
        self.delegate?.presenterDidUpdate()
    }
    
}
