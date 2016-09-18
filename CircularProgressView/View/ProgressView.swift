//
//  ProgressView.swift
//  CircularProgressView
//
//  Created by Ankit Angra on 18/09/16.
//  Copyright © 2016 Ankit Angra. All rights reserved.
//

import UIKit


class ProgressView: UIView {
    
    var progressTintColor: UIColor? {
        get {
            return (self.layer as! ProgressLayer).progressTintColor!
        }
        set(newColor) {
            (self.layer as! ProgressLayer).progressTintColor = newColor
        }
    }
    
    var trackTintColor: UIColor? {
        get {
            return (self.layer as! ProgressLayer).trackTintColor!
        }
        set(newColor) {
            (self.layer as! ProgressLayer).trackTintColor = newColor
        }
    }
    
    var progress: Float {
        get {
            return (self.layer as! ProgressLayer).progress
        }
        set(newProgress) {
            (self.layer as! ProgressLayer).progress = newProgress
        }
    }
    
    override class func layerClass() -> AnyClass {
        return ProgressLayer.self
    }
    
    private func customInitialize() {
        self.layer.contentsScale = UIScreen.mainScreen().scale
        self.layer.setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        customInitialize()
    }
}

class ProgressLayer: CALayer {
    
    @NSManaged var progress: Float
    @NSManaged var progressTintColor: UIColor?
    @NSManaged var trackTintColor: UIColor?
    
    override class func needsDisplayForKey(key: String) -> Bool {
        return key == "progress" || super.needsDisplayForKey(key)
    }
    
    override func actionForKey(event: String) -> CAAction? {
        if event == "progress" {
            guard trackTintColor != nil && progressTintColor != nil else {return nil}
            
            if let presentationLayer = self.presentationLayer() as? CALayer {
                let anim = CABasicAnimation(keyPath: event)
                anim.fromValue = presentationLayer.valueForKey(event)
                return anim
            }
        }
        return super.actionForKey(event)
    }
    
    override func drawInContext(ctx: CGContext) {
        let circleRect = CGRectInset(self.bounds, 1, 1)
        
        CGContextSetStrokeColorWithColor(ctx, trackTintColor?.CGColor)
        CGContextSetLineWidth(ctx, 1.0)
        
        CGContextStrokeEllipseInRect(ctx, circleRect)
        
        let radius = min(CGRectGetMidX(circleRect), CGRectGetMidY(circleRect))
        let center = CGPointMake(radius, CGRectGetMidY(circleRect))
        let startAngle = Float(-M_PI / 2)
        let endAngle = self.progress * 2 * Float(M_PI) + startAngle
        CGContextSetFillColorWithColor(ctx, progressTintColor?.CGColor)
        CGContextMoveToPoint(ctx, center.x, center.y)
        CGContextAddArc(ctx, center.x, center.y, radius, CGFloat(startAngle), CGFloat(endAngle), 0)
        CGContextFillPath(ctx)
        
        super.drawInContext(ctx)
    }
}