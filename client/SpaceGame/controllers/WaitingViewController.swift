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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLbl.text = usernameTxt
        sendToServer(username: usernameTxt)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SocketIOManager.sharedInstance.listen(event: "GameIsReady", callback: { (data, ack) in
            self.performSegue(withIdentifier: "GameViewController", sender: nil)
        })
    }
    
    func sendToServer(username: String) {
        let player = Player(name: username)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(player)
            print(jsonData)
            if let json = String(data: jsonData, encoding: .utf8) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    print("socket write")
                    SocketIOManager.sharedInstance.emit(event: "playerConnect", message: ["player": json])
                }
            }
        } catch {
            print("error")
        }
    }
}
