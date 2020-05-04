//
//  WaitingViewController.swift
//  SpaceGame
//
//  Created by Florian on 27/04/2020.
//  Copyright © 2020 blandinf. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {
    @IBOutlet weak var usernameLbl: UILabel!
    var usernameTxt = ""
    var player: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLbl.text = usernameTxt
        if !usernameTxt.isEmpty {
            player = Player(name: usernameTxt)
            sendToServer(player: player!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SocketIOManager.sharedInstance.listen(event: "GameIsReady", callback: { (data, ack) in
            self.performSegue(withIdentifier: "GameViewController", sender: nil)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameViewController" {
            if let destination = segue.destination as? GameViewController {
                if let myPlayer = player {
                    destination.currentPlayer = myPlayer
                }
            }
        }
    }
    
    func sendToServer(player: Player) {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(player)
            print(jsonData)
            if let json = String(data: jsonData, encoding: .utf8) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    print("send playerConnect")
                    SocketIOManager.sharedInstance.emit(event: "playerConnect", message: ["player": json])
                }
            }
        } catch {
            print("error")
        }
    }
}
