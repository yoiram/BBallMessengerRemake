//
//  BallBehaviour.swift
//  BBallMessengerRemake
//
//  Created by Mario Youssef on 2016-04-28.
//  Copyright © 2016 Mario Youssef. All rights reserved.
//

import Foundation
import UIKit

class BallBehavior: UIDynamicBehavior {
    let gravity = UIGravityBehavior()
    let push = UIPushBehavior()

    
    lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedBallBehavior = UIDynamicItemBehavior()
        lazilyCreatedBallBehavior.allowsRotation = true
        lazilyCreatedBallBehavior.elasticity = 0.5
        return lazilyCreatedBallBehavior
    }()
    
    lazy var rimBehavior: UICollisionBehavior = {
        let lazilyCreatedRimBehavior = UICollisionBehavior()
        lazilyCreatedRimBehavior.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedRimBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(ballBehavior)
        addChildBehavior(rimBehavior)
        addChildBehavior(push)
    }
    
    func addVelocity(velocity: UInt, ball:UIImageView) {
        //ballBehavior.addLinear
        //ballBehavior.addLinearVelocity(CGPoint.zero, forItem: ball)
    }
    
    func addBall(ball: UIImageView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        gravity.addItem(ball)
        ballBehavior.addItem(ball)
        rimBehavior.addItem(ball)
    }
    
    func removeBall(ball: UIImageView) {
        gravity.removeItem(ball)
        ballBehavior.removeItem(ball)
        rimBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func addRim(path: UIBezierPath, named name: String){
        rimBehavior.removeBoundaryWithIdentifier(name)
        rimBehavior.addBoundaryWithIdentifier(name, forPath: path)
    }
}

