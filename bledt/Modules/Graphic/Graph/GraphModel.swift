//
// File:      GraphModel
// Module:    Graphic
// Package:   bledt
//
// Author:    Roderic Linguri <rlinguri@mac.com>
// Copyright: © 2019 Roderic Linguri. All Rights Reserved.
// License:   MIT
//
// Requires:  > Swift 5.0 && > iOS 12.0
// Version:   0.2.3
// Since:     0.2.2
//

/// Store and compute properties to be used by the graph
class GraphModel {
    
    // MARK: - Updateable Properties
    
    /// The base used to calculate dynamic values
    var rect: CGRect = CGRect.zero

    /// The coordinates we will use to draw the line
    var coordinates: [Coordinate] = []

    // MARK: - Constant Properties
    
    /// Top margin constant (8.0)
    let topMargin: CGFloat = 8.0
    
    /// Bottom margin constant (-28.0)
    let bottomMargin: CGFloat = -28.0
    
    /// Left margin constant (28.0)
    let leftMargin: CGFloat = 28.0
    
    /// Right Margin constant (16.0)
    let rightMargin: CGFloat = 16.0
    
    // MARK: - Computed Properties
    
    /// Computed height based on screen
    var height: CGFloat {
        return self.rect.height - ((UIScreen.main.bounds.height * 0.18) + 40)
    }
    
    /// Computed width based on bounds
    var width: CGFloat {
        return self.rect.width
    }
    
    /// How many labels will fit accross the width
    var labelCount: Int {
        return Int((self.width - self.leftMargin - self.rightMargin) / 96)
    }
    
    /// Keep a separate delta for the x axis labels
    var xLabelDelta: CGFloat {
        return (self.width - self.leftMargin - self.rightMargin) / CGFloat(labelCount)
    }
    
    /// Milliseconds to Points ratio
    var xDelta: CGFloat {
        return (self.width - self.leftMargin - self.rightMargin) / CGFloat(self.coordinates.count)
    }
    
    /// SampleCount to Points ratio
    var yDelta: CGFloat {
        return (self.height - self.bottomMargin - self.topMargin) / 18.0
    }
    
    /// Y Offset for the x axis legend
    var labelY: CGFloat {
        return self.height - 10.0
    }
    
}
