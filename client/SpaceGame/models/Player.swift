//
//  Player.swift
//  SpaceGame
//
//  Created by Florian on 27/04/2020.
//  Copyright © 2020 blandinf. All rights reserved.
//

import Foundation

public enum PlayerError: Error {
    case creationFailed
}

struct Player: Codable {
    let id: String
    let name: String
}
