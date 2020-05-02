//
//  WaitingViewController.swift
//  SpaceGame
//
//  Created by Florian on 27/04/2020.
//  Copyright © 2020 blandinf. All rights reserved.
//

import UIKit
import Starscream

class WaitingViewController: UIViewController {
    var socket: WebSocket!
    var isConnected = false
    @IBOutlet weak var usernameLbl: UILabel!
    var usernameTxt = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = WebSocket(request: URLRequest(url: URL(string: "ws://localhost:8080/")!))
        socket.delegate = self
        socket.connect()
        usernameLbl.text = usernameTxt
        sendToServer(username: usernameTxt)
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
                    self.socket.write(string: json)
                }
            }
        } catch {
            print("error")
        }
    }
}

extension WaitingViewController: WebSocketDelegate {
    
     func didReceive(event: WebSocketEvent, client: WebSocket) {
         switch event {
            case .connected(let headers):
                isConnected = true
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                print("string \(string)")
                if let dict = convertToDictionary(text: string) {
                    print("dict \(dict)")
                    if let bool = dict["bothAreConnected"] {
                        print("OOOOK")
                        if bool as! Bool == true {
                            print("switch")
                            self.performSegue(withIdentifier: "GameViewController", sender: nil)
                        }
                    }
                } else {
                    print("dict wtf")
                }
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viablityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                isConnected = false
            case .error(let error):
                isConnected = false
                handleError(error)
        }
     }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
     
     private func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
}
