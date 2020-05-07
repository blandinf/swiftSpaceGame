//
//  GameViewController.swift
//  SpaceGame
//
//  Created by Florian on 17/04/2020.
//  Copyright © 2020 blandinf. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var currentPlayer: Player? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                scene.gameDelegate = self
                view.presentScene(scene)
                whoIsTheWinner(scene: scene)
            }
            view.ignoresSiblingOrder = true
            view.showsPhysics = true
        }
    }
    
    func whoIsTheWinner(scene: GameScene) {
        SocketIOManager.sharedInstance.listen(event: "winnerIs", callback: { (data, ack) in
            if let player = self.currentPlayer {
                if let result = data[0] as? String {
                    if player.id == result {
                         scene.displayYourRank(true)
                    } else {
                         scene.displayYourRank()
                    }
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: GameDelegate {
    
    func gameOver() {
        let jsonEncoder = JSONEncoder()
        do {
            if let player = currentPlayer {
                let jsonData = try jsonEncoder.encode(player)
                print(jsonData)
                if let json = String(data: jsonData, encoding: .utf8) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        print("send playerIsDead")
                        SocketIOManager.sharedInstance.emit(event: "playerIsDead", message: ["player": json])
                    }
                }
            }
        } catch {
            print("error")
        }
    }
}
