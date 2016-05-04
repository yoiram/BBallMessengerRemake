//
//  ViewController.swift
//  BBallMessengerRemake
//
//  Created by Mario Youssef on 2016-04-27.
//  Copyright © 2016 Mario Youssef. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIDynamicAnimatorDelegate {
    
    //init constants and variables
    var currentScore = 0
    var firstShot = true
    var shot = false
    var passedTop = false
    var madeNet = false
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
    
    func makeNet() { //create 2 new collision items in position of the basketball rim
        //let dim = CGSize(width: 110.0, height: 10.0)
        //var rim = CGRect(origin: basketBallnet.center, size: dim)
        //rim.origin.x = (UIScreen.mainScreen().bounds.width/2) - 50
        //rim.origin.y += 5
        
        let left = CGRect(x: (UIScreen.mainScreen().bounds.width/2) - 65, y: basketBallnet.center.y+5, width: 10.0, height: 10.0)
        let right = CGRect(x: (UIScreen.mainScreen().bounds.width/2) + 55, y: basketBallnet.center.y+5, width: 10.0, height: 10.0)
        
        //let path = UIBezierPath(rect: rim)
        
        let rimL = UIBezierPath(ovalInRect: left)
        let rimR = UIBezierPath(ovalInRect: right)
        ballBehavior.addRim(rimL, named: "left")
        ballBehavior.addRim(rimR, named: "Right")
        gameView.addEdges(rimL, named: "Left")
        gameView.addEdges(rimR, named: "Right")
        madeNet = true
    }
    
    func removeNet() { //remove collision items from ballBehavior
        ballBehavior.removeRim(named: "Left")
        ballBehavior.removeRim(named: "Right")
        madeNet = false
    }
    
    func reset() {
        if (firstShot) { //if first shot, reset score and ball
            currentScore = 0
            scoreLabel.text = "Score: \(currentScore)"
            if (lastBall != nil) {
                ballBehavior.removeBall(lastBall!)
                
            }
            ballBehavior.addBall(createBall(false))
            firstShot = false
        }
        else { //else increment and add new ball with random position
            incrementScore()
            ballBehavior.removeBall(lastBall!)
            ballBehavior.addBall(createBall(true))
        }
        shot = false
    }
    
    func createBall(rand:Bool) -> UIImageView {
        var frame = CGRect(x: mid, y: vstart, width: 75.0, height: 75.0) //initialize the size of the ball to be
        
        if (rand) { //will assign the ball to a random position if true is passed
            let possiblePositions = Int (UIScreen.mainScreen().bounds.width/frame.width)
            print(possiblePositions)
            print(gameView.bounds.size.width)
            print(UIScreen.mainScreen().bounds.width, mid)
            frame.origin.x = CGFloat.random(possiblePositions) * frame.width
        }
        
        let ball = UIImageView(frame: frame) //creates ball
        ball.contentMode = UIViewContentMode.ScaleAspectFill
        ball.image = UIImage(named:"basketball")! //sets image of the ball to basketball
        ball.layer.cornerRadius = ball.frame.size.height/2 //makes it a circle
        ball.layer.borderWidth = 0
        lastBall = ball
        return ball
    }
    
    @IBAction func shoot(sender: UIPanGestureRecognizer) {
        if(shot == true) { //if already shot, will not shoot again
            return
        }
        let pushBehavior : UIPushBehavior!
        var x : CGFloat
        var y : CGFloat
        var angle : CGFloat
        
        switch sender.state {
        case .Began: break
        case .Ended: //will push the ball in the direction of swipe
            x = sender.velocityInView(self.gameView).x
            y = sender.velocityInView(self.gameView).y
            angle = atan2(y, x)
            pushBehavior = createPushBehavior(angle)
            pushBehavior.addItem(lastBall!)
            shot = true
        default: break
        }
        firstShot = false
    }
    
//    func evaluate() {
//        let curr = lastBall?.center.y
//        print(curr)
//        print(basketBallnet.center.y+5)
//        if(curr <= basketBallnet.center.y+5) {
//            makeNet()
//            passedTop = true
//        }
//        else {
//            evaluate()
//        }
//    }
    
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