//
//  GameScene.swift
//  FlappyBirdSwift
//
//  Created by Wilson Koder on 13/7/14.
//  Copyright (c) 2014 WilsonKoder. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    
    var pipesMoveAndRemove = SKAction()
    
    let pipeGap = 150.0
    
    override func didMoveToView(view: SKView) {
        
        //Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -1)
        
        //Bird
        var birdTexture = SKTexture(imageNamed:"bird")
        //change texture filtering mode.
        birdTexture.filteringMode = SKTextureFilteringMode.Nearest
        //Make the object.
        bird = SKSpriteNode(texture: birdTexture)
        //set scale
        bird.setScale(0.5)
        //position it.
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.width * 0.6)
        
        //give it the collision collider of a circle.
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        bird.physicsBody.dynamic = true
        bird.physicsBody.allowsRotation = false
        
        //add it to the scene
        self.addChild(bird)
        
        //ground/floor
        
        var groundTexture = SKTexture(imageNamed:"floor")
        var sprite = SKSpriteNode(texture: groundTexture)
        //scale it
        sprite.setScale(2.0)
        //position it
        sprite.position = CGPointMake(self.size.width / 2, sprite.size.height / 2)
        
        //add it to the scene
        self.addChild(sprite)
        
        //ground variable for the node
        var ground = SKSpriteNode()
        
        //set the position of the node
        ground.position = CGPointMake(0, groundTexture.size().height)
        
        //set the physics body to equal the size of the image.
        ground.physicsBody = SKPhysicsBody(rectangleOfSize:CGSizeMake(self.frame.size.width, groundTexture.size().height * 2.0))
        
        //dont let the object move
        ground.physicsBody.dynamic = false
        
        //add the object to the scene
        self.addChild(ground)
        
        //Pipes
        
        //Create the Pipes.
        pipeUpTexture = SKTexture(imageNamed:"pipeup")
        pipeDownTexture = SKTexture(imageNamed:"pipedown")
        
        //movement of pipes?
        
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeUpTexture.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y: 0, duration: NSTimeInterval(0.01 * distanceToMove))
        
        let removePipes = SKAction.removeFromParent()
        
        pipesMoveAndRemove = SKAction.sequence([movePipes, removePipes])
        
        //Spawn the Pipes
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        
        self.runAction(spawnThenDelayForever)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            bird.physicsBody.velocity = CGVectorMake(0, 0)
            bird.physicsBody.applyImpulse(CGVectorMake(0, 10))
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func spawnPipes() {
       
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipeUpTexture.size().width * 2, 0)
        
        pipePair.zPosition = -10
        
        let height = UInt32(self.frame.size.height / 4)
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
        
        pipeDown.setScale(2.0)
        pipeDown.position = CGPointMake(0, CGFloat(y) + pipeDown.size.height + CGFloat(pipeGap))
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize:pipeDown.size)
        pipeDown.physicsBody.dynamic = false
        
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
        
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(y))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize:pipeUp.size)
        pipeUp.physicsBody.dynamic = false
        
        pipePair.addChild(pipeUp)
        
        pipePair.runAction(pipesMoveAndRemove)
        
        self.addChild(pipePair)
    }
}
