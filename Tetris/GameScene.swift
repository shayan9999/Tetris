//
//  GameScene.swift
//  Tetris
//
//  Created by Shayan K. on 5/16/16.
//  Copyright (c) 2016 PiSociety. All rights reserved.
//

import SpriteKit


let TickLevelOne        = NSTimeInterval(600);

class GameScene: SKScene {
    
    var tick: (() -> ())? // function pointer - can be nil and should return nothing and take no parameters
    var tickLength  = TickLevelOne // tickLength which I will change based on time
    var lastTick: NSDate? // used in comparision to see when was the last tick
    
    required init(coder aCoder: NSCoder){
        fatalError("Not Found Coder");
    }
    
    
    // need to override size method of Scene to tell it what size this scene is of
    override init(size: CGSize){
        
        super.init(size: size)
        anchorPoint = CGPointMake(0, 1.0)
        let bgSprite = SKSpriteNode(imageNamed: "background")
        bgSprite.anchorPoint = CGPointMake(0, 1.0)
        self.addChild( bgSprite)
    }
    
    //MARK: - Update functions
    
    override func update(currentTime: CFTimeInterval){
        
        // dont execute update function if lastTick is nil - game is paused
        guard let lastTickValue = lastTick else{
            return
        }
        
        let timePassed = lastTickValue.timeIntervalSinceNow * -1000.0
        if(timePassed > tickLength){
            self.lastTick = NSDate()
            if tick != nil{
                tick!()
            }
        }
        
    }
    
    func startTicking(){
        lastTick = NSDate()
    }
    
    func stopTicking(){
        lastTick = nil;
    }
    
    //MARK: - View interaction functions
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
}
