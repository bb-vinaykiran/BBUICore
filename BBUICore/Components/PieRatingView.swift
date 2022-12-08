//
//  PieRatingView.swift
//  Animations
//
//  Created by Khushal Dugar on 20/06/19.
//  Copyright © 2019 Khushal Dugar. All rights reserved.
//

import UIKit

@IBDesignable public class PieRatingView: UIView {
    
    @IBInspectable public var highlightedColor: UIColor = UIColor.green {
        didSet {
        }
    }
    @IBInspectable public var normalColor: UIColor = AppAssetConfigManager.colorProvider(.kSeperatorColor) {
        didSet {
        }
    }
    @IBInspectable public var percentage: CGFloat = 50 {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            self.setNeedsDisplay()
        }
    }
    @IBInspectable public var roundViewWidth: CGFloat = 5 {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            self.setNeedsDisplay()
        }
    }
    
    let ratingLabel = UILabel()
    
    fileprivate func setup() {
        ratingLabel.center = self.center
        self.addSubview(ratingLabel)
        
        ratingLabel.font = UIFont.systemFont(ofSize: (self.frame.width-roundViewWidth*2)/4 )
        ratingLabel.text = "1.2"
        ratingLabel.sizeToFit()
        ratingLabel.textColor = UIColor.red
        ratingLabel.setNeedsLayout()
        ratingLabel.layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // setup()
    }
    
    public override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        let radius = min(frame.size.width, frame.size.height) * 0.5 - roundViewWidth/2
        
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        
        let startAngle = -CGFloat.pi * 0.5
       
            let endAngle = startAngle + 2 * .pi * (percentage/100)
        
        ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        ctx?.setStrokeColor(highlightedColor.cgColor)
        ctx?.setLineWidth(roundViewWidth)
            ctx?.strokePath()
        ctx?.addArc(center: viewCenter, radius: radius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
        ctx?.setStrokeColor(normalColor.cgColor)
        ctx?.setLineWidth(roundViewWidth)
        ctx?.strokePath()
        ctx?.fillPath()
        
        let lastPoint = CGPoint(x: viewCenter.x + radius*cos(endAngle), y: viewCenter.y + radius*sin(endAngle))
        ctx?.addArc(center: CGPoint(x: bounds.size.width * 0.5, y: roundViewWidth/2), radius: roundViewWidth/2, startAngle: 90 * .pi / 180, endAngle: 270 * .pi / 180, clockwise: false)
        ctx?.setFillColor(highlightedColor.cgColor)
        ctx?.fillPath()
        
        
        ctx?.addArc(center: lastPoint, radius: roundViewWidth/2, startAngle: endAngle, endAngle: endAngle + .pi, clockwise: false)
        ctx?.fillPath()
    }
    
    
    public override func prepareForInterfaceBuilder() {
        setup()
    }
    
}
