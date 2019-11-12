//
// File:      Storage
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

/// Saves and retrieves data
class Storage {
    
    /// A Storage Error
    struct Error {
        /// Error to display if save fails
        static var saveError: NSError {
            return NSError(
                domain: "com.digices",
                code: 9992,
                userInfo: ["NSLocalizedDescription": "The data could not be saved"]
            )
        }
        
        /// Error to display if load fails
        static var loadError: NSError {
            return NSError(
                domain: "com.digices",
                code: 9993,
                userInfo: ["NSLocalizedDescription": "The data could not be loaded"]
            )
        }
        
        /// Error to display if reset fails
        static var resetError: NSError {
            return NSError(
                domain: "com.digices",
                code: 9994,
                userInfo: ["NSLocalizedDescription": "The data could not reset"]
            )
        }
    }
    
    /// Save data to filename
    ///
    /// - Parameter data: the data to be saved
    /// - Parameter file: string reprenting the filename
    func save(data: Data, to file: String) {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(file)
        do {
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
            }
            fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            let error = Error.saveError
            print(error.localizedDescription)
        }
    }
    
    /// Load data from file
    ///
    /// - Parameter file: The file name
    ///
    /// - Returns: data | nil
    func load(from file: String) -> Data? {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(file)
        if let data = fileManager.contents(atPath: url.path) {
            return data
        } else {
            let error = Error.loadError
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Remove stored data
    ///
    /// - Parameter file: The file name
    func reset(file: String) {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(file)
        if fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.removeItem(at: url)
            } catch {
                let resetError = Error.resetError
                print("\(resetError.localizedDescription)\n\(error.localizedDescription)")
            }
        }
    }
    
}
