//
//  GameViewController.swift
//  Tetris
//
//  Created by Shayan K. on 5/16/16.
//  Copyright (c) 2016 PiSociety. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameDelegate {

    
    var gameScene: GameScene! // without asterisk it was throwing an error to create an init method too ??!?!
    var gameEngine: GameEngine!
    
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
        gameEngine.letShapeFall()
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
            self.gameScene.startTicking()
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
        gameScene.stopTicking()
    }
    
    func gameDidLevelUp(swiftris: GameEngine) {
        
    }
    
    func gameShapeDidDrop(swiftris: GameEngine) {
        
    }
    
    func gameShapeDidLand(swiftris: GameEngine) {
        gameScene.stopTicking()
        nextShape()
    }
    
    // #17
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
}
