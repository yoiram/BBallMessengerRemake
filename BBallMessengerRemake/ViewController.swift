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
    var passedTop = false
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
        //basketBallnet.hidden = true
        reset()
        makeNet()
    }
    
    func incrementScore() {
        currentScore += 1
        scoreLabel.text = "Score: \(currentScore)"
    }
    
    func makeNet() {
//        let dim = CGSize(width: 100.0, height: 10.0)
//        var rim = CGRect(origin: basketBallnet.center, size: dim)
//        rim.origin.x = (UIScreen.mainScreen().bounds.width/2) - 50
//        rim.origin.y += 5
        
        let left = CGRect(x: (UIScreen.mainScreen().bounds.width/2) - 65, y: basketBallnet.center.y+5, width: 20.0, height: 10.0)
        let right = CGRect(x: (UIScreen.mainScreen().bounds.width/2) + 45, y: basketBallnet.center.y+5, width: 20.0, height: 10.0)
        
        //let path = UIBezierPath(rect: rim)
        
        let rimL = UIBezierPath(ovalInRect: left)
        let rimR = UIBezierPath(ovalInRect: right)
        
        //ballBehavior.addRim(path, named: "Rim")
        //gameView.addEdges(path, named: "Rim")
        
        ballBehavior.addRim(rimL, named: "left")
        ballBehavior.addRim(rimR, named: "Right")
        gameView.addEdges(rimL, named: "Left")
        gameView.addEdges(rimR, named: "Right")
    }
    
    func removeNet() {
        ballBehavior.removeRim(named: "Left")
        ballBehavior.removeRim(named: "Right")
    }
    
//    func evaluator() {
//        repeat {
//            if (lastBall?.center.y >= (basketBallnet.center.y+5)) {
//                top = true
//                makeNet()
//            }
//        } while !passedTop
//    }

    
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