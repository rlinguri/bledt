//
// File:      Batch
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

/// A sequence of samples
struct Batch {
    
    /// The sequence of the batch in the file
    var seq: Int
    
    /// An array of Samples
    var data: [Sample]
    
    /// Compute whether or not the batch is complete
    var isComplete: Bool {
        return self.data.count == 16
    }
    
}
