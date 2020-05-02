//
//  LoginViewController.swift
//  SpaceGame
//
//  Created by Florian on 27/04/2020.
//  Copyright © 2020 blandinf. All rights reserved.
//

import UIKit
import Starscream

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    var socket: WebSocket!
    var isConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socketConnection()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WaitingViewController" {
            if let destination = segue.destination as? WaitingViewController {
                if let username = username.text {
                    destination.usernameTxt = username
                }
            }
        }
    }
    
    func socketConnection() {
       socket = WebSocket(request: URLRequest(url: URL(string: "ws://localhost:8080/")!))
       socket.connect()
    }
    
    @IBAction func connect(_ sender: Any) {
        
    }
}
