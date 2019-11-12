//
// File:      Coordinate
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

/// A point representing a batch in time
struct Coordinate {
    
    /// When was the batch captured
    var milliseconds: Int
    
    /// How many samples does it contain
    var samples: Int
    
}
