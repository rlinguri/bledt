//
// File:      GraphView
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

import UIKit

/// A UIView that draws a graph
class GraphView: UIView {
    
    /// The instance that provides all our constants and computed properties
    let model = GraphModel()
        
    /// An array of coordinates to draw
    var coordinates: [Coordinate] = [] {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// Draw the Graph View
    ///
    /// - Parameter rect: The portion of the view’s bounds that needs to be updated
    override func draw(_ rect: CGRect) {
                
        // Clear out any views we've previously added
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        // update the model's rect so we can get the correct calculations
        self.model.rect = self.bounds
        
        let path = UIBezierPath()
        
        var i: Int = 0
        
        for coordinate in self.model.coordinates {
            
            // convert coordinates for better display
            let xPos = (CGFloat(i) * self.model.xDelta) + self.model.leftMargin
            let yPos = self.model.height - (self.model.yDelta * CGFloat(coordinate.samples))
            
            // make a point from the coordinates
            let nextPoint = CGPoint(
                x: xPos,
                y: yPos
            )
                        
            // first point needs the move method
            if i == 0 {
                path.move(to: nextPoint)
            } else {
                path.addLine(to: nextPoint)
            }
            
            // add legend for x axis
            if i % 15 == 0 {
                
                let label = GraphLabel(frame: CGRect(
                    x: nextPoint.x,
                    y: self.model.labelY,
                    width: 96.0,
                    height: 12.0
                ))
                
                let msStr = "\(coordinate.milliseconds)".leftPadding(
                    toLength: 6,
                    withPad: "0"
                )
                
                label.text = "\(msStr.prefix(3)):\(msStr.suffix(3))"
                
                self.addSubview(label)
            }
            
            i += 1
        }

        path.lineWidth = 2.0
        path.lineJoinStyle = .round
        UIColor.systemBlue.setStroke()
        path.stroke()

        // Create legend for y axis
        for i in 1...16 {
            let frame = CGRect(x: 0.0, y: self.model.height - (self.model.yDelta * CGFloat(i)), width: 18.0, height: 12.0)
            let label = GraphLabel(frame: frame)
            label.text = "\(i)"
            label.textAlignment = .right
            self.addSubview(label)
        }
        
    }
}
