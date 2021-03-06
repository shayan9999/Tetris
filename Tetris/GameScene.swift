//
//  GameScene.swift
//  Tetris
//
//  Created by Shayan K. on 5/16/16.
//  Copyright (c) 2016 PiSociety. All rights reserved.
//

import SpriteKit
import UIKit


class GameScene: SKScene {
    
    //MARK: - Constants
    let gameLayer       = SKNode()
    let shapeLayer      = SKNode()
    let LayerPosition   = CGPoint(x: 4, y: -8)
    
    //MARK: - Variables
    var bgSprite: SKSpriteNode?
    //var backgroundMusic: SKAudioNode!

    var tick: (() -> ())? // function pointer - can be nil and should return nothing and take no parameters
    var tickLength  = TickLevelOne // tickLength which I will change based on time
    var lastTick: NSDate? // used in comparision to see when was the last tick
    
    var textureCache = Dictionary<String, SKTexture>()
    
    required init(coder aCoder: NSCoder){
        fatalError("Not Found Coder");
    }
    
    
    // creates the game scene with layers, sprites and positioning
    override init(size: CGSize){
        
        super.init(size: size)
        anchorPoint = CGPointMake(0, 1.0)
        //bgSprite = SKSpriteNode(imageNamed: "background")
        //bgSprite!.anchorPoint = CGPointMake(0, 1.0)
        //self.addChild(bgSprite!)
        
        self.addChild(gameLayer)
        
        let grayBox = SKTexture(imageNamed: "gameboard")
        let gameArea = SKSpriteNode(texture: grayBox, size: CGSizeMake(tetrisBlockSize * CGFloat(totalTetrisColumns), tetrisBlockSize * CGFloat(totalTetrisRows)))
        gameArea.anchorPoint = CGPoint(x:0, y:1.0)
        gameArea.position = LayerPosition
        
        shapeLayer.position = LayerPosition
        shapeLayer.addChild(gameArea)
        gameLayer.addChild(shapeLayer)
        
        // start game theme sound
        runAction(SKAction.repeatActionForever(SKAction.playSoundFileNamed("theme0.mp3", waitForCompletion: true)))
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
    
    func resumeGameTimer(){
        lastTick = NSDate()
    }
    
    func stopGameTimer(){
        lastTick = nil;
    }
    
    //MARK: - View interaction functions
    
//    override func didMoveToView(view: SKView) {
//        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!"
//        myLabel.fontSize = 45
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        
//        self.addChild(myLabel)
//    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//       /* Called when a touch begins */
//        
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
//    }
    
    //MARK: - Helper Functions
    
    // converts rows and columns into game world positions
    func getPointFromPosition(column: Int, row: Int) -> CGPoint{
        let xPosition = LayerPosition.x + (CGFloat(column) * tetrisBlockSize) + (tetrisBlockSize/2)
        let yPosition = LayerPosition.y - (CGFloat(row) * tetrisBlockSize) //+ (tetrisBlockSize/4)
        
        return CGPointMake(xPosition, yPosition)
    }
    
    // adds the shape which is shown in preview to the game layer
    func addPreviewShapeToGameScene(shape: Shape2D, completion:()->()){
        
        for block in shape.blocks{
            
            // create a texture for this block in the shape, set it to the sprite and add ir to the sprite's layer
            var textureForBlock = textureCache[block.spriteName]
            if(textureForBlock == nil){
                textureForBlock     = SKTexture(imageNamed: block.spriteName)
                textureCache[block.spriteName] = textureForBlock
            }
            
            let spriteForBlock  = SKSpriteNode(texture: textureForBlock)
            
            // Animating the way this block appears into the screen
            spriteForBlock.position = self.getPointFromPosition(block.column, row: block.row - 2)
            self.shapeLayer .addChild(spriteForBlock)
            block.sprite = spriteForBlock
            
            spriteForBlock.alpha = 0.0;
            
            let moveAction  = SKAction.moveTo( self.getPointFromPosition(block.column, row: block.row + 3), duration: NSTimeInterval(0.2))
            moveAction.timingMode   = SKActionTimingMode.EaseOut
            
            let fadeAction  = SKAction.fadeAlphaTo(0.7, duration: 0.4)
            
            spriteForBlock.runAction(SKAction.group([moveAction, fadeAction]))
            }
        
        // Call the completion function
        runAction(SKAction.waitForDuration(0.4), completion: completion)
    }
    
    // After updating values for rows and columns for a block, we call this function to update the shape's position
    func movePreviewShape(shape: Shape2D, completion:() -> ()) {
        
        for block in shape.blocks {
            
            let spriteForBlock = block.sprite!
            
            let moveTo = self.getPointFromPosition(block.column, row:block.row)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: 0.2)
            moveToAction.timingMode = SKActionTimingMode.EaseOut
            
            // Animating how this block will move
            spriteForBlock.runAction(
                SKAction.group([moveToAction, SKAction.fadeAlphaTo(1.0, duration: 0.2)]), completion: {})
        }
        
        // Call the completion function
        runAction(SKAction.waitForDuration(0.2), completion: completion)
    }
    
    func redrawShape(shape: Shape2D, completion:() -> ()) {
        for block in shape.blocks {
            
            let spriteForBlock = block.sprite!
            
            let moveTo = self.getPointFromPosition(block.column, row:block.row)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: 0.05)
            moveToAction.timingMode = SKActionTimingMode.EaseOut
            
            if block == shape.blocks.last {
                // call the completion method as well when the last block has been redrawn
                spriteForBlock.runAction(moveToAction, completion: completion)
            } else {
                spriteForBlock.runAction(moveToAction)
            }
        }
    }
    
    func playSound(soundFileName: String) {
        runAction(SKAction.playSoundFileNamed(soundFileName, waitForCompletion: false))
    }
    
//    func startBackgroundMusic(){
//        backgroundMusic = SKAudioNode(fileNamed: "theme0.mp3")
//        addChild(backgroundMusic)
//    }
//    
//    func stopBackgroundMusic(){
//        backgroundMusic.runAction(SKAction.stop())
//    }
    
    // Aniamtes removal of lines 
    //TODO: Work on animations on this
    func animateCollapsingLines(linesToRemove: Array<Array<Block2D>>, fallenBlocks: Array<Array<Block2D>>, completion:() -> ()) {
        
        // how long need to wait before completion block
        var timeTillCompletion: NSTimeInterval = 0
        
        
        for (columnIdx, column) in fallenBlocks.enumerate() {
            for (blockIdx, block) in column.enumerate() {
                
                let newPosition = self.getPointFromPosition(block.column, row: block.row)
                let sprite = block.sprite!
                
                // setting up animation timing
                let delay = (NSTimeInterval(columnIdx) * 0.05) + (NSTimeInterval(blockIdx) * 0.05)
                let duration = NSTimeInterval(((sprite.position.y - newPosition.y) / tetrisBlockSize) * 0.1)
                let moveAction = SKAction.moveTo(newPosition, duration: duration)
                moveAction.timingMode = .EaseOut
                sprite.runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(delay),
                        moveAction]))
                timeTillCompletion = max(timeTillCompletion, duration + delay)
            }
        }
        
        for rowToRemove in linesToRemove {
            
            for block in rowToRemove {
                
                // put some randomization in animatons
                let randomRadius = CGFloat(UInt(arc4random_uniform(200) + 100))
                let goLeft = arc4random_uniform(100) % 2 == 0
                
                var point = self.getPointFromPosition(block.column, row: block.row)
                point = CGPointMake(point.x + (goLeft ? -randomRadius : randomRadius), point.y)
                
                let randomDuration = NSTimeInterval(arc4random_uniform(2)) + 0.5
                
                // add some rotations
                var startAngle = CGFloat(M_PI)
                var endAngle = startAngle * 2
                if goLeft {
                    endAngle = startAngle
                    startAngle = 0
                }
                let archPath = UIBezierPath(arcCenter: point, radius: randomRadius, startAngle: startAngle, endAngle: endAngle, clockwise: goLeft)
                let archAction = SKAction.followPath(archPath.CGPath, asOffset: false, orientToPath: true, duration: randomDuration)
                archAction.timingMode = .EaseIn
                let sprite = block.sprite!
                
                // make the blocks appear above other blocks so they dont hide
                // behind blocks that will not be removed yet
                sprite.zPosition = 100
                sprite.runAction(
                    SKAction.sequence(
                        [SKAction.group([archAction, SKAction.fadeOutWithDuration(NSTimeInterval(randomDuration))]),
                            SKAction.removeFromParent()]))
            }
        }
        
        runAction(SKAction.waitForDuration(timeTillCompletion), completion:completion)
    }

   
}
