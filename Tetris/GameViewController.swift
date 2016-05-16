//
//  GameViewController.swift
//  Tetris
//
//  Created by Shayan K. on 5/16/16.
//  Copyright (c) 2016 PiSociety. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    
    var gameScene: GameScene! // without asterisk it was throwing an error to create an init method too ??!?!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configuring the view set-up
        let spriteKitView = self.view as! SKView //downcast to SKView
        spriteKitView.multipleTouchEnabled = false
        
        // create new scene and set some properties
        gameScene = GameScene(size: spriteKitView.bounds.size)
        
        spriteKitView.presentScene( gameScene)
        
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

    override func shouldAutorotate() -> Bool {
        return true
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
