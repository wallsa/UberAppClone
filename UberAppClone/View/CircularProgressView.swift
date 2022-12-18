//
//  CircularProgressView.swift
//  UberAppClone
//
//  Created by Wallace Santos on 17/12/22.
//

import UIKit

class CircularProgressView: UIView {
    
    
//MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCircleLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Properties
    
    private var progressLayer:CAShapeLayer!
    private var trackLayer:CAShapeLayer!
    private var pulsatingLayer:CAShapeLayer!
    
//MARK: - Helper Functions
    
    private func configureCircleLayers(){
        pulsatingLayer = circuleShapeLayer(strokeColor: .clear, fillColor: .pulsatingFillColor)
        layer.addSublayer(pulsatingLayer)
        
        trackLayer = circuleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .clear)
        layer.addSublayer(trackLayer)
        trackLayer.strokeEnd = 1
        
        progressLayer = circuleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        layer.addSublayer(progressLayer)
        progressLayer.strokeEnd = 1
        
        
    }
    
    private func circuleShapeLayer(strokeColor:UIColor, fillColor:UIColor) -> CAShapeLayer{
        let layer = CAShapeLayer()
        let center = CGPoint(x: 0, y: 32)
        
        let circularPath = UIBezierPath(arcCenter: center, radius: self.frame.width / 2.5, startAngle: -(.pi / 2), endAngle: 1.5 * .pi, clockwise: true)
        
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.fillColor = fillColor.cgColor
        layer.lineWidth = 12
        layer.lineCap = .round
        layer.position = self.center
        
        return layer
    }
    
    func animatePulsatingLayer(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.25
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    func setProgressWithAnimation(duration : TimeInterval, value : Float, completion:@escaping () -> ()){
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = duration
        animation.fromValue = 1
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateProgress")
        
        CATransaction.commit()
    }
    
}
