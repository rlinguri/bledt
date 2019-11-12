//
// File:      DataManager
// Module:    Global
// Package:   bledt
//
// Author:    Roderic Linguri <rlinguri@mac.com>
// Copyright: © 2019 Roderic Linguri. All Rights Reserved.
// License:   MIT
//
// Requires:  > Swift 5.0 && > iOS 12.0
// Version:   0.2.3
// Since:     0.1.5
//

/// Protocol for any instance that wishes to receive DataManager messages
protocol DataManagerDelegate: class {
    
    /// Called when the DataManager has fetched data
    ///
    /// - Parameter data: The data that was fetched
    func didRetrieveData(data: Data)
    
    /// Called when the DataManager has encountered an error
    ///
    /// - Parameter error: the error that was encountered
    func didProduceError(error: Error)

}

/// Network and Storage operations interface
class DataManager {
    
    /// A DataManager Error
    struct Error {
        
        /// Error to display if the URL fails
        static var urlError: NSError {
            let error = NSError(
                domain: "com.digices",
                code: 9998,
                userInfo: ["NSLocalizedDescription": "Cannot create url from provided string"]
            )
            return error
        }

    }
    
    // MARK: - Instance Properties
    
    /// The instance to try to send messages to
    var delegate: DataManagerDelegate?
    
    /// The instance that fetches from the interwebs
    let network: Network
    
    /// The instance that stores/retrieves data locally
    let storage: Storage
    
    /// The current dataset
    var data: Data?
    
    let fileName: String = "ble_data.txt"
    
    let urlString: String = "https://digices.com/bledt/ble_data.txt"
    
    // MARK: - Instance Methods
    
    /// Initialize a new `DataManager` instance
    ///
    /// - Parameter storage: The instance that fetches from the interwebs
    /// - Parameter network: The instance that stores/retrieves data locally
    init(storage: Storage, network: Network) {
        self.network = network
        self.storage = storage
    }
    
    /// Retrieve data from storage or from network
    func retrieve() {
        if let storedData = self.storage.load(from: self.fileName) {
            self.data = storedData
            self.delegate?.didRetrieveData(data: storedData)
        } else {
            self.fetch()
        }
    }
    
    /// Reload data from the network
    func fetch() {
        if let url = URL(string: self.urlString) {
            self.network.delegate = self
            self.network.fetchData(from: url)
        } else {
            self.delegate?.didProduceError(error: Error.urlError as NSError)
        }
    }
    
}

/// NetworkDelegate
extension DataManager: NetworkDelegate {
    
    /// Called by Network instance when data has been fetched
    ///
    /// - Parameter data: the data that was fetched
    func didFetchData(data: Data) {
        self.data = data
        self.storage.save(data: data, to: self.fileName)
        self.delegate?.didRetrieveData(data: data)
    }
    
    /// Called by Network instance when an error was encountered
    ///
    /// - Parameter error: A Swift `Error` instance
    func didProduceError(error: Swift.Error) {
        self.delegate?.didProduceError(error: error)
    }
    
}
