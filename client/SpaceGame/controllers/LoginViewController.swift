//
//  LoginViewController.swift
//  SpaceGame
//
//  Created by Florian on 27/04/2020.
//  Copyright © 2020 blandinf. All rights reserved.
//

import UIKit
import SocketIO

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
