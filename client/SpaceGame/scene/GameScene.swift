//
//  GameScene.swift
//  SpaceGame
//
//  Created by Florian on 17/04/2020.
//  Copyright © 2020 blandinf. All rights reserved.
//

import SpriteKit
import AVKit

enum CollisionType: UInt32 {
    case player = 1
    case playerWeapon = 2
    case enemy = 4
    case enemyWeapon = 8
}

class GameScene: SKScene {
    let PLAYER_HEIGHT: CGFloat = 30.0
    let PLAYER_WIDTH: CGFloat = 75.0
    let player = SKSpriteNode(imageNamed: "player")
    let waves = Bundle.main.decode([Wave].self, from: "waves.json")
    let enemyTypes = Bundle.main.decode([EnemyType].self, from: "enemy-types.json")
    let gameOverImg = SKSpriteNode(imageNamed: "gameOver")
    var avPlayer = AVPlayer()

    
    var isPlayerAlive = true
    var levelNumber = 0
    var waveNumber = 0
    var playerShield = 3
    var beginning = true
    var gameDelegate: GameDelegate?
    
    let positions = Array(stride(from: -320, through: 320, by: 80))
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        //player first position
        player.name = "player"
        player.position.x = frame.minX + PLAYER_WIDTH + 100
        player.zPosition = 1
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.texture!.size())
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        player.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        player.physicsBody?.isDynamic = false
        //        launchVideoInLoop()
    }
    
    func launchVideoInLoop() {
//        let videoNode: SKVideoNode? = {
//            guard let urlString = Bundle.main.path(forResource: "video", ofType: "mp4") else { return nil }
//            let url = URL(fileURLWithPath: urlString)
//            let item = AVPlayerItem(url: url)
//            avPlayer = AVPlayer(playerItem: item)
//            
//            return SKVideoNode(avPlayer: avPlayer)
//        }()
//        
//        videoNode?.position = CGPoint( x: frame.midX, y: frame.midY)
//        videoNode?.zPosition = 0
//        addChild((videoNode)!)
//        avPlayer.play()
//        
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem, queue: nil)
//        { notification in
//            self.avPlayer.seek(to: CMTime.zero)
//            self.avPlayer.play()
//            print("reset Video")
//        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            player.position.y = location.y
            
            if player.position.y + PLAYER_HEIGHT > frame.maxY {
                player.position.y = frame.maxY - PLAYER_HEIGHT
            } else if player.position.y - PLAYER_HEIGHT < frame.minY {
                player.position.y = frame.minY + PLAYER_HEIGHT
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for child in children {
            if child.frame.maxX < 0 {
                if !frame.intersects(child.frame) {
                    child.removeFromParent()
                }
            }
        }
        
        let activeEnemies = children.compactMap{ $0 as? EnemyNode }
        
        if activeEnemies.isEmpty {
            createWave()
        }
    }
    
    func createWave() {
        guard isPlayerAlive else { return }
        
        if waveNumber == waves.count {
            levelNumber += 1
            waveNumber = 0
        }
        
        let currentWave = waves[waveNumber]
        waveNumber += 1
        
        let maximumEnemyType = min(enemyTypes.count, levelNumber + 1)
        let enemyType = Int.random(in: 0..<maximumEnemyType)
        
        let enemyOffsetX: CGFloat = 100
        let enemyStartX = 600

        if currentWave.enemies.isEmpty {
            for (index, position) in positions.shuffled().enumerated() {
                let enemy = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: enemyStartX, y: position), xOffset: enemyOffsetX * CGFloat(index * 3), moveStraight: true)
                addChild(enemy)
            }
        } else {
            for enemy in currentWave.enemies {
                let node = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: enemyStartX, y: positions[enemy.position]), xOffset: enemyOffsetX * enemy.xOffset, moveStraight: enemy.moveStraight)
                addChild(node)
            }
        }
    }
    
    func gameOver () {
        isPlayerAlive = false
        if let delegate = self.gameDelegate {
            delegate.gameOver()
        }
        
        addChild(gameOverImg)
    }
    
    func displayYourRank (_ winner: Bool = false) {
        gameOverImg.removeFromParent()
        if winner {
            let winner = SKSpriteNode(imageNamed: "winner")
            addChild(winner)
        } else {
            let looser = SKSpriteNode(imageNamed: "looser")
            addChild(looser)
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        let sortedNodes = [nodeA, nodeB].sorted { $0.name ?? "" < $1.name ?? "" }
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        if secondNode.name == "player" {
            guard isPlayerAlive else { return }
            
            playerShield -= 1
            
            if playerShield == 0 {
                gameOver()
                secondNode.removeFromParent()
            }
            firstNode.removeFromParent()
        }
    }
}
