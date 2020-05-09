//
//  BonusType.swift
//  SpaceGame
//
//  Created by Florian on 07/05/2020.
//  Copyright © 2020 blandinf. All rights reserved.
//

import SpriteKit

struct BonusType: Codable {
    let name: String
    let speed: CGFloat
    let chanceToAppear: CGFloat
    let width: Int
    let height: Int
    let variety: Int
}
