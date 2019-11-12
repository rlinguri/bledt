//
// File:      GraphLabel
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

/// A Custom label to be drawn into the graph
class GraphLabel: UILabel {
    
    /// Initialize a `GraphLabel` Instance
    ///
    /// - Parameter frame: The frame rectangle for the view
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = .lightGray
        self.font = UIFont(name: "Menlo-Regular", size: 9.0)
    }
    
    /// Required init (not implemented)
    ///
    /// - Parameter coder: an `NSCoder` instance
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
