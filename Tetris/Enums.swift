//
//  Enums.swift
//  Tetris
//
//  Created by Shayan K. on 5/17/16.
//  Copyright © 2016 PiSociety. All rights reserved.
//

import Foundation

/*  ---------------------------------------------------------------------------------------
    Defines the colors enum which represents all the colors
    in the blocks
 */
enum Color: Int, CustomStringConvertible{
    
    case Blue = 0, Orange, Purple, Red, Teal, Yellow
    
    // To conform to the CustomStringConvertible interface, enum has to describe this method
    var description: String{
        return self.spriteName
    }
    
    // converts enum value to strings - used in description method also to get file names
    // this is a computed variable which means it returns value based on computation
    // this was not in objective-C!
    var spriteName: String{
        switch self {
            case .Blue: return "blue"
            case .Orange: return "orange"
            case .Purple: return "purple"
            case .Red: return "red"
            case .Teal: return "teal"
            case .Yellow: return "yellow"
        }
    }
    
    // gets you a random color among 6
    static func randomColor() -> Color{
        return Color(rawValue: Int(arc4random_uniform(numberOfColors)))!
    }
}

/*  ---------------------------------------------------------------------------------------
    Defines the orientations that our Tetris shapes can be in
 */

enum Orientation: Int, CustomStringConvertible{
    
    case Up = 0, Right, Down, Left
    
    var description: String{
        switch self {
            case .Up: return "up"
            case .Right: return "right"
            case .Down: return "down"
            case .Left: return "left"
        }
    }
    
    // returns a random orientation among 4
    static func randomOrientation() -> Orientation{
        return Orientation(rawValue: Int(arc4random_uniform(totalOrientations)))!
    }
    
    // applies rotation clockwise or counter clockwise to any orientation
    static func rotate(orientationFrom: Orientation, clockwise: Bool) -> Orientation{
        let rotationEffect = clockwise ? 1 : -1
        var rotatedResult = orientationFrom.rawValue + rotationEffect
        
        if(rotatedResult  > Orientation.Left.rawValue){
            rotatedResult = Orientation.Up.rawValue
        }else if (rotatedResult < 0){
            rotatedResult = Orientation.Left.rawValue
        }
        
        return Orientation(rawValue: rotatedResult)!
    }
}