//
//  HappinessViewController.swift
//  happiness
//
//  Created by 李弋 on 7/27/15.
//  Copyright (c) 2015 李弋. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource
{
    
    @IBOutlet weak var faceView: FaceView!{
        didSet {
            faceView.dataSource = self
            happiness = 100
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scaleface:"))
        }
    }
    
    private struct Constrains {
        static let HappinessGestureScale: CGFloat = 4
    }

    var happiness: Int = 0 {   //0 = very sad, 100 = ecstatic
        didSet   {
            println("Happiness is \(happiness)")
            happiness = min(max(happiness, 0), 100)
            
            updateUI()
        }
    }
    @IBAction func changeHappiness(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(faceView)
            let happinessChange = Int(translation.y / Constrains.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                sender.setTranslation(CGPointZero, inView: faceView)
            }
        default: break
        }
    }
    
    var scaleF: Double = 0.1
 
//    @IBAction func changeScale(sender: UIPinchGestureRecognizer) {
//        switch sender.state {
////                case .Ended: fallthrough
//                case .Changed:
//                    scaleF *= sender.scale
//                    sender.scale = 1
//                    println("\(scaleF)")
//        case .Began: println("begin")
//        case .Changed: println("changed")
//        case .Ended: println("ended")
//        default: break
//        }
//    }
    
  
    
    func    updateUI()
    {
            faceView.setNeedsDisplay()
    }
    
    func getHappinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50)/50
    }
    
    func changeShape (sender: FaceView) ->Double? {
        return scaleF
    }
    
    
}
