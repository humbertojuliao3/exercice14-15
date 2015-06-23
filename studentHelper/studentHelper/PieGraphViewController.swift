//
//  PieGraphViewController.swift
//  collegeHelper
//
//  Created by Gabriel Alberto de Jesus Preto on 18/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@IBDesignable
class PieGraphViewController: UIView {
    var backgroundLayer: CAShapeLayer!
    var lineWidth: Double = 0.0
    
    var pieOverLayer: CAShapeLayer!
    
    @IBInspectable
    var piePercentage: Double = 0{
        willSet(newPiePercentage) {
            updatePiePercentage(newPiePercentage)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineWidth = Double(self.frame.size.width)/2
        
        if !(backgroundLayer != nil){
            backgroundLayer = CAShapeLayer()
            layer.addSublayer(backgroundLayer)
            
            let rect = CGRectInset(bounds, CGFloat(lineWidth/2.0), CGFloat(lineWidth/2.0))
            let path = UIBezierPath(ovalInRect: rect)
            
            backgroundLayer.path = path.CGPath
            
            backgroundLayer.fillColor = nil
            backgroundLayer.lineWidth = CGFloat(lineWidth)
            backgroundLayer.strokeColor = UIColor(white: 0.5, alpha: 0.3).CGColor
            
        }
        
        backgroundLayer.frame = layer.bounds
        
        if !(pieOverLayer != nil){
            pieOverLayer = CAShapeLayer()
            layer.addSublayer(pieOverLayer)
            
            let rect = CGRectInset(bounds, CGFloat(lineWidth/2.0), CGFloat(lineWidth/2.0))
            let path = UIBezierPath(ovalInRect: rect)
            
            pieOverLayer.path = path.CGPath
            
            pieOverLayer.fillColor = nil
            pieOverLayer.lineWidth = CGFloat(lineWidth)
            pieOverLayer.strokeColor = UIColor(red: 237/255, green: 37/255, blue: 75/255, alpha: 1).CGColor
            
            pieOverLayer.anchorPoint = CGPointMake(0.5, 0.5)
            
            pieOverLayer.transform = CATransform3DRotate(pieOverLayer.transform, CGFloat(-M_PI/2), 0, 0, 1)
            
        }
        
        pieOverLayer.frame = layer.bounds
        
        pieOverLayer.zPosition = 1
        
        self.updateLayerProperties()
        
    }
    
    func updatePiePercentage(newPiePercentage: Double){
        if(pieOverLayer != nil){
            CATransaction.begin()
            var animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = ((newPiePercentage/100) - (self.piePercentage/100)) * 3
            animation.fromValue = self.piePercentage/100
            animation.toValue = newPiePercentage / 100
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            CATransaction.setCompletionBlock({ () -> Void in
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey:kCATransactionDisableActions)
                self.pieOverLayer.strokeEnd = CGFloat(newPiePercentage/100)
                
                CATransaction.commit()
            })
            
            self.pieOverLayer.addAnimation(animation, forKey: "animateStrokeEnd")
            CATransaction.commit()
        }
    }
    
    func updateLayerProperties(){
        if (pieOverLayer != nil){
            self.pieOverLayer.strokeEnd = CGFloat(piePercentage/100)
        }
    }

}