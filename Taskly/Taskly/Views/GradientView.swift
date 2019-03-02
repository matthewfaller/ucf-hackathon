//
//  BackgroundView.swift
//  Taskly
//
//  Created by Matthew Faller on 10/30/18.
//  Copyright © 2018 Royal Bank of Canada. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientView: UIView {

    private let time = 0.80
    
    @IBInspectable
    var startColor: UIColor = .white {
        didSet {
            var animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
            
            animation.fromValue = [oldValue.cgColor, endColor.cgColor]
            animation.toValue = [startColor, endColor.cgColor]
            
            animation.fillMode = .forwards
            
            animation.isRemovedOnCompletion = false
            
            animation.duration = time
            
            gradient?.add(animation, forKey: "animateGradient")
//            rebuildGradient()
        }
    }
    
    @IBInspectable
    var endColor: UIColor = .gray {
        didSet {
            var animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
            
            animation.fromValue = [startColor.cgColor, oldValue.cgColor]
            animation.toValue = [startColor.cgColor, endColor.cgColor]
            
            animation.fillMode = .forwards
            
            animation.isRemovedOnCompletion = false
            
            animation.duration = time
            
            gradient?.add(animation, forKey: "animateGradient")
        }
    }
    
    @IBInspectable
    private var isHorizontal: Bool = false
    
    @IBInspectable
    private var isSloped: Bool = false
    
    private var startPoint: CGPoint {
        
        if isHorizontal {
            return CGPoint(x: 0, y: 0.5)
        } else if isSloped {
            return CGPoint(x: 0, y: 0)
            
        } else {
            return CGPoint(x: 0.5, y: 0)
        }
    }
    
    private var endPoint: CGPoint {
        
        if isHorizontal {
            return CGPoint(x: 1, y: 0.5)
        } else if isSloped {
            return CGPoint(x: 1, y: 1)
            
        } else {
            return CGPoint(x: 0.5, y: 1)
        }
    }
    
    override var frame: CGRect {
        didSet {
            rebuildGradient()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rebuildGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rebuildGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        rebuildGradient()
    }
    
    private var gradient: CAGradientLayer?
    
    private func rebuildGradient() {
        
       if let grad = self.gradient {
            grad.removeFromSuperlayer()
       }
        
        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = self.bounds
        gradientlayer.startPoint = self.startPoint
        gradientlayer.endPoint = self.endPoint
        gradientlayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        //        layer.addSublayer(gradientlayer)
        self.layer.insertSublayer(gradientlayer, at: 0)
        self.gradient = gradientlayer
       
    }
}
