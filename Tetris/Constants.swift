//
//  Constants.swift
//  Tetris
//
//  Created by Shayan K. on 5/17/16.
//  Copyright © 2016 PiSociety. All rights reserved.
//

import Foundation

let numberOfColors: UInt32                      = 6
let totalOrientations: UInt32                   = 4
let totalShapes: UInt32                         = 7

let FirstBlockIdx: Int                          = 0
let SecondBlockIdx: Int                         = 1
let ThirdBlockIdx: Int                          = 2
let FourthBlockIdx: Int                         = 3

//MARK: - Extension methods for custom classes

// Equality operator for Block2D  objects
func ==(lhs: Block2D, rhs: Block2D) -> Bool{
    return (lhs.column == rhs.column) && (lhs.row == lhs.row) && (rhs.color.rawValue == lhs.color.rawValue)
}

// Equality operator for Shape2D Objects
func ==(lhs: Shape2D, rhs: Shape2D) -> Bool{
    return (lhs.column == rhs.column) && (lhs.row == lhs.row) 
}
