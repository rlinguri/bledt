//
// File:      Network
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

/// Protocol for any instance that wishes to receive network messages
protocol NetworkDelegate: class {

    /// Called by Network instance when data has been fetched
    ///
    /// - Parameter data: the data that was fetched
    func didFetchData(data: Data)

    /// Called by Network instance when an error was encountered
    ///
    /// - Parameter error: A Swift `Error` instance
    func didProduceError(error: Error)

}

/// Get data from the interwebs
class Network {

    /// A Network Error
    struct Error {
        
        /// No Data Error
        static var noData: NSError {
            return NSError(
                domain: "com.digices",
                code: 9999,
                userInfo: ["NSLocalizedDescription": "There was an error fetching the data"]
            )
        }
        
        /// Timeout Error
        static var timeout: NSError {
            return NSError(
                domain: "com.digices",
                code: 9995,
                userInfo: ["NSLocalizedDescription": "The request timed out"]
            )
        }
        
        /// HTTP Status Error
        ///
        /// - Parameter code: the HTTP Status Code
        static func httpError(code: Int) -> NSError {
            return NSError(
                domain: "com.digices",
                code: code,
                userInfo: ["NSLocalizedDescription": "The server responded with HTTP Status Code \(code)"]
            )
        }
        
    }
    
    /// Who we will send messages to
    var delegate: NetworkDelegate?
    
    /// Network timeout
    var timer: Timer?
    
    /// Completion Handler for the data task
    ///
    /// - Parameter data: the data from the response
    /// - Parameter response: HTTPResponse object
    /// - Parameter error: An optional error
    private func completionHandler(data: Data?, response: URLResponse?, error: Swift.Error?) {
        guard let response = response as? HTTPURLResponse,
            let data = data else {
                DispatchQueue.main.async {
                    self.stopTimer()
                    self.delegate?.didProduceError(error: Error.noData)
                }
                return
        }
        
        if response.statusCode == 200 {
            DispatchQueue.main.async {
                self.stopTimer()
                self.delegate?.didFetchData(data: data)
            }
        } else {
            DispatchQueue.main.async {
                self.stopTimer()
                self.delegate?.didProduceError(error: Error.httpError(code: response.statusCode))
            }
        }
    }
    
    /// Begin timing the network request
    private func startTimer() {
        self.timer = Timer.scheduledTimer(
            timeInterval: 5.0,
            target: self,
            selector: #selector(Network.timeout),
            userInfo: nil,
            repeats: false
        )
    }
    
    /// Invalidate and nullify the timer
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /// Selector to trigger when deadline is reached
    @objc func timeout() {
        self.timer?.invalidate()
        self.timer = nil
        self.delegate?.didProduceError(error: Error.timeout)
    }
    
    /// Download data from a URL into memory
    ///
    /// - Parameter url: the URL to download from
    func fetchData(from url: URL) {
        let task = URLSession.shared.dataTask(
            with: url,
            completionHandler: self.completionHandler
        )
        self.startTimer()
        task.resume()
    }
    
}
