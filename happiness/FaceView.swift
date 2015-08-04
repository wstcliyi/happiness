//
//  FaceView.swift
//  happiness
//
//  Created by 李弋 on 7/27/15.
//  Copyright (c) 2015 李弋. All rights reserved.
//

import UIKit

protocol FaceViewDataSource : class {
    func getHappinessForFaceView (sender: FaceView) ->Double?
    func changeShape (sender: FaceView) ->Double?
}
@IBDesignable
class FaceView: UIView {
    
    weak var dataSource : FaceViewDataSource?
    

    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay()}  }

    var color: UIColor = UIColor.yellowColor() { didSet {  setNeedsDisplay() }  }
    var scaleFace: CGFloat =  0.99 { didSet { setNeedsDisplay() } }
    
    var faceCenter: CGPoint {
        return convertPoint(center, fromView:  superview)
    }
    var faceRadius: CGFloat {

        var radius =  scaleFace * min(bounds.size.width, bounds.size.height)/2
        println(radius)
        return min(max(radius, 3), min(bounds.size.width, bounds.size.height)/2)
    }
   

    
    
    
        func scaleface(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scaleFace *= gesture.scale
            gesture.scale = 1
        }
    }
    
    override func drawRect(rect: CGRect) {
  
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0 , endAngle: CGFloat(2*M_PI) , clockwise: true)
        
        println("Radius is \(faceRadius) /n")

        
        
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        let happiNess = dataSource?.getHappinessForFaceView(self) ?? 0.0
  
//        let scaleF = dataSource?.changeShape(self) ?? 0.4
//        scaleFace = CGFloat(scaleF)
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        smelinessPath(happiNess).stroke()
        
    }
    
    private struct  Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 8
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeperationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1.2
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
        
    }
    
    private enum Eye { case Left, Right }
    
    private func bezierPathForEye(whichEye: Eye) ->UIBezierPath
    {
        let eyeRadius = faceRadius /  Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVertical = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeSeperation = faceRadius / Scaling.FaceRadiusToEyeSeperationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y  -= eyeVertical
        
        println("eyeRadius is \(eyeRadius)) /n")
        println("eyeSeperation is \(eyeSeperation) /n")
        
        
        switch(whichEye ) {
        case .Left : eyeCenter.x   -=  eyeSeperation/2
        case .Right: eyeCenter.x += eyeSeperation/2
        }
        let eyePath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0 , endAngle: CGFloat(2*M_PI) , clockwise: true)
        eyePath.lineWidth = lineWidth
        return eyePath
    }
    
    
    private func smelinessPath(isHappy : Double) -> UIBezierPath
    {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(-1, min(CGFloat( isHappy), 1) ) * mouthHeight )
        
        let start = CGPoint( x: faceCenter.x - mouthWidth/2, y: faceCenter.y + mouthOffset )
        let end = CGPoint( x: start.x + mouthWidth, y: start.y)
        
        let controlP = CGPoint (x: faceCenter.x, y: start.y + smileHeight )
        
        let path = UIBezierPath()
//        path.addCurveToPoint(<#endPoint: CGPoint#>, controlPoint1: <#CGPoint#>, controlPoint2: <#CGPoint#>)
        path.moveToPoint(start)
        path.addQuadCurveToPoint(end, controlPoint: controlP)
        path.lineWidth = lineWidth
        return path
    }
    
        



}
