//
//  Block2D.swift
//  Tetris
//
//  Created by Shayan K. on 5/17/16.
//  Copyright © 2016 PiSociety. All rights reserved.
//

import Foundation
import SpriteKit


class Block2D: Hashable, CustomStringConvertible{
    
    //MARK: - Constants
    
    let color: Color
    
    //MARK: - Variables
    
    var column: Int
    var row: Int
    var sprite: SKSpriteNode?
    
    
    //MARK: - Initializations
    
    init(column: Int, row: Int, color: Color){
        self.column = column;
        self.row = row;
        self.color = color;
    }
    
    //MARK: - Information Methods
    
    var spriteName: String{
        return color.spriteName
    }
    
    var hashValue: Int{
        return self.column ^ self.row
    }
    
    var description: String{
        return "\(color) Block at [\(row), \(column)]"
    }
}