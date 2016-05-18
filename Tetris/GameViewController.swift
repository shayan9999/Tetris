//
//  GameViewController.swift
//  Tetris
//
//  Created by Shayan K. on 5/16/16.
//  Copyright (c) 2016 PiSociety. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameDelegate, UIGestureRecognizerDelegate {

    
    var gameScene: GameScene! // without asterisk it was throwing an error to create an init method too ??!?!
    var gameEngine: GameEngine!
    var referenceTappedPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configuring the view set-up
        let spriteKitView = self.view as! SKView //downcast to SKView
        spriteKitView.multipleTouchEnabled = false
        
        // create new scene and set some properties
        gameScene = GameScene(size: spriteKitView.bounds.size)
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        
        
        // assigning the function for gameScene this function will be called on every frame update now
        gameScene.tick = gameTick
        
        // creating and setting up game engine
        gameEngine = GameEngine()
        gameEngine.delegate = self
        gameEngine.beginGame()
        
        spriteKitView.presentScene( gameScene)
        
//        gameScene.addPreviewShapeToGameScene(gameEngine.nextShape!) { 
//            self.gameEngine.nextShape?.moveTo(tetrisStartingColumn, row: tetrisStartingRow)
//            self.gameScene.movePreviewShape(self.gameEngine.nextShape!) {
//                let nextShapes = self.gameEngine.newShape()
//                self.gameScene.startTicking()
//                self.gameScene.addPreviewShapeToGameScene(nextShapes.nextShape!) {}
//            }
//        }
        
        /* This code was there by default
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
//        }
 
         */
    }
    
    //MARK: - GameController methods
    
    func gameTick(){
        gameEngine.letCurrentShapeFall()
        // Old methd:
        //gameEngine.fallingShape?.moveDown()
        //gameScene.redrawShape(gameEngine.fallingShape!, completion: {})
    }
    
    func nextShape() {
        let newShapes = gameEngine.newShape()
        guard let fallingShape = newShapes.fallingShape else {
            return
        }
        self.gameScene.addPreviewShapeToGameScene(newShapes.nextShape!) {}
        self.gameScene.movePreviewShape(fallingShape) {
            self.view.userInteractionEnabled = true
            self.gameScene.resumeGameTimer()
        }
    }
    
    //MARK: - GameDelegate methods
    
    func gameDidBegin(swiftris: GameEngine) {
        // The following is false when restarting a new game
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            gameScene.addPreviewShapeToGameScene(swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(swiftris: GameEngine) {
        view.userInteractionEnabled = false
        self.gameScene.stopGameTimer()
        self.gameScene.playSound("gameover.mp3")
        
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.gameEngine.beginGame()
        })
    }
    
    func gameDidLevelUp(swiftris: GameEngine) {
        
    }
    
    func gameShapeDidDrop(swiftris: GameEngine) {
        self.gameScene.stopGameTimer()
        self.gameScene.redrawShape(swiftris.fallingShape!) {
            swiftris.letCurrentShapeFall()
        }
    }
    
    func gameShapeDidLand(swiftris: GameEngine) {
        // stop timer and push next shape in
        gameScene.stopGameTimer()
        //nextShape()
        
        // Pause interaction for a while
        self.view.userInteractionEnabled = false
        
        // Find the lines that match line break criteria and remove them
        let removedLines = swiftris.getCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            //TODO: Animate things here 
            //TODO: Update score here
            //TODO: Play any sound here
            self.gameScene.playSound("line_complete.wav")
            //self.scoreLabel.text = "\(swiftris.score)"
            self.gameScene.animateCollapsingLines(removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
                // Do somethings here and then call itself to be able to do nextShape()
                self.gameShapeDidLand(swiftris)
            }
        
        } else {
            nextShape()
        }
    }
    
    func gameShapeDidMove(swiftris: GameEngine) {
        gameScene.redrawShape(swiftris.fallingShape!) {}
    }
    
    //MARK: - ViewController methods

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: - GestureRecognizer delegate methods
    
    
    // Tap Gesture Recognizer method
    @IBAction func tappedView(sender: AnyObject) {
        self.gameEngine.rotateCurrentShape();
    }
    
    // Pan Gesture Recognizer method
    @IBAction func movedFingers(sender: AnyObject) {
        
        // The point where user tapped in this view
        let fingerOnPoint = sender.translationInView(self.view)
        
        if let originalPoint = referenceTappedPoint {
            
            // if moved at least as much as block size
            if abs(fingerOnPoint.x - originalPoint.x) > (tetrisBlockSize * 0.9) {
                
                // if moved towards right, move the current shape to right
                if sender.velocityInView(self.view).x > CGFloat(0) {
                    self.gameEngine.moveCurrentShapeRight()
                    referenceTappedPoint = fingerOnPoint
                }
                // similarly for left
                else {
                    self.gameEngine.moveCurrentShapeLeft()
                    referenceTappedPoint = fingerOnPoint
                }
            }
        } else if sender.state == UIGestureRecognizerState.Began {
            // set the last reference point if the gesture has just begun
            referenceTappedPoint = fingerOnPoint
        }
    }
    
    @IBAction func swipedFingers(sender: AnyObject) {
        self.gameEngine.dropCurrentShape();
    }
    
    // need to implement these two methods as other gesture recognizers were not working with swipe.
    // found this solution online at stackoverflow
    // Priorities defined as: Pan/Tap > Swipe
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // this recognizer should stop listening if the other recognizer is swipe gesture recognizer
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        // this recognizer should stop listening if the other is tap gesture recognizer
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        return false
    }

}
