//
//  Constants.swift
//  Tetris
//
//  Created by Shayan K. on 5/17/16.
//  Copyright © 2016 PiSociety. All rights reserved.
//

import Foundation
import UIKit

// count defaults
let numberOfColors: UInt32                      = 6
let totalOrientations: UInt32                   = 4
let totalShapes: UInt32                         = 7

// Shape Indexes
let FirstBlockIdx: Int                          = 0
let SecondBlockIdx: Int                         = 1
let ThirdBlockIdx: Int                          = 2
let FourthBlockIdx: Int                         = 3

// Game defaults
let totalTetrisColumns                          = 10
let totalTetrisRows                             = 20
let tetrisStartingColumn                        = 4
let tetrisStartingRow                           = 2
let tetrisBlockSize: CGFloat                    = 20.0
let tetrisRowForPreviewShape                    = 1

// Game Score defaults
let PointsPerLine                               = 10
let LevelThreshold                              = 500

//MARK: - Extension methods for custom classes

// Equality operator for Block2D  objects
func ==(lhs: Block2D, rhs: Block2D) -> Bool{
    return (lhs.column == rhs.column) && (lhs.row == lhs.row) && (rhs.color.rawValue == lhs.color.rawValue)
}

// Equality operator for Shape2D Objects
func ==(lhs: Shape2D, rhs: Shape2D) -> Bool{
    return (lhs.column == rhs.column) && (lhs.row == lhs.row) 
}
