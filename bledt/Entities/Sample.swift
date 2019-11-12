//
// File:      Sample
// Module:    Entities
// Package:   bledt
//
// Author:    Roderic Linguri <rlinguri@mac.com>
// Copyright: © 2019 Roderic Linguri. All Rights Reserved.
// License:   MIT
//
// Requires:  > Swift 5.0 && > iOS 12.0
// Version:   0.2.3
// Since:     0.1.4
//

/// A 20 byte string
struct Sample {
    
    /// An integer between 0 and 15
    var seq: Int
    
    /// The remaining data stored as a string
    var data: String
    
    /// Initialize a `Sample`
    ///
    /// - Parameter subsequence: a 40-character substring
    init(subsequence: String.SubSequence) {
        
        // extract the first two characters
        let hex = subsequence.prefix(2)
        
        // attempt to convert to an integer
        if let num = UInt64(hex, radix: 16) {
            self.seq = Int(num)
        } else {
            // force tests to fail if unable to convert
            self.seq = 16
        }
        
        // save the remainder of the data, for possible future use
        self.data = String(subsequence.suffix(38))
    }
    
}
