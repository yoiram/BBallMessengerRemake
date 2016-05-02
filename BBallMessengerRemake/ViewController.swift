//
//  ViewController.swift
//  BBallMessengerRemake
//
//  Created by Mario Youssef on 2016-04-27.
//  Copyright © 2016 Mario Youssef. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIDynamicAnimatorDelegate {
    
    var currentScore = 0
    var firstShot = true
    let mid = UIScreen.mainScreen().bounds.width/2 - 37.5
    let vstart = UIScreen.mainScreen().bounds.height/2
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var basketBallnet: UIImageView!
    @IBOutlet weak var gameView: CourtView!
    @IBOutlet var pan: UIPanGestureRecognizer!
    
    lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazilyCreatedDynamicAnimator.delegate = self
        return lazilyCreatedDynamicAnimator
    }()
    
    let ballBehavior = BallBehavior()
    var lastBall:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(ballBehavior)
        reset()
    }
    
    func incrementScore() {
        currentScore += 1
        scoreLabel.text = "Score: \(currentScore)"
    }
    
    
    func reset() {
        if (firstShot) {
            currentScore = 0
            scoreLabel.text = "Score: \(currentScore)"
            if (lastBall != nil) {
                ballBehavior.removeBall(lastBall!)
                
            }
            ballBehavior.addBall(createBall(false))
            firstShot = false
        }
        else {
            incrementScore()
            ballBehavior.removeBall(lastBall!)
            ballBehavior.addBall(createBall(true))
        }
        
    }
    
    func createBall(rand:Bool) -> UIImageView {
        var frame = CGRect(x: mid, y: vstart, width: 75.0, height: 75.0)
        if (rand) {
            let possiblePositions = Int (UIScreen.mainScreen().bounds.width/frame.width)
            print(possiblePositions)
            print(gameView.bounds.size.width)
            print(UIScreen.mainScreen().bounds.width, mid)
            frame.origin.x = CGFloat.random(possiblePositions) * frame.width
        }
        let ball = UIImageView(frame: frame)
        ball.contentMode = UIViewContentMode.ScaleAspectFill
        ball.image = UIImage(named:"basketball")!
        ball.layer.cornerRadius = ball.frame.size.height/2
        ball.layer.borderWidth = 0
        lastBall = ball
        return ball
    }
    
//    func scored() {
//        incrementScore()
//        //let y = basketBall.frame.origin.y
//        //let x = newBallPosX()
//        
//        basketBall.frame = CGRect(x: x, y: y, width: basketBall.frame.size.width, height: basketBall.frame.size.height)
//    }
    
    @IBAction func shoot(sender: UIPanGestureRecognizer) {
        let pushBehavior : UIPushBehavior!
        var x : CGFloat
        var y : CGFloat
        var angle : CGFloat
        
        switch sender.state {
        case .Began: break
        case .Ended:
            x = sender.velocityInView(self.gameView).x
            y = sender.velocityInView(self.gameView).y
            angle = atan2(y, x)
            pushBehavior = createPushBehavior(angle)
            pushBehavior.addItem(lastBall!)
        default: break
        }
        firstShot = false
    }
    
    func createPushBehavior(angle: CGFloat)->UIPushBehavior {
        let pushBehavior = UIPushBehavior(items: [], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = 6
        pushBehavior.angle = angle
        pushBehavior.action = { [unowned pushBehavior] in
            pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior)
        }
        animator.addBehavior(pushBehavior)
        return pushBehavior
    }
}

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}