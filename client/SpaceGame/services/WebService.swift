//
//  WebService.swift
//  SpaceGame
//
//  Created by Florian on 27/04/2020.
//  Copyright © 2020 blandinf. All rights reserved.
//

import Foundation
import Starscream

class WebService {
    var socket: WebSocket
    
    init() {
        socket = WebSocket(request: URLRequest(url: URL(string: "ws://localhost:8080/")!))
        socket.connect()
    }
}
