//
//  Square2D.swift
//  Tetris
//
//  Created by Shayan K. on 5/17/16.
//  Copyright © 2016 PiSociety. All rights reserved.
//

import Foundation

class Square2D: Shape2D {
    /*
     // #9
     | 0•| 1 |
     | 2 | 3 |
     
     • marks the row/column indicator for the shape
     
     */
    
    // The square shape will not rotate
    
    // #10
    override var blockPositionsForOrientations: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        return [
            Orientation.Up: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.Down: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.Left: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.Right: [(0, 0), (1, 0), (0, 1), (1, 1)]
        ]
    }
    
    // #11
    override var bottomBlocksForOrientations: [Orientation: Array<Block2D>] {
        return [
            Orientation.Up:         [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Down:       [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Left:       [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Right:      [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]]
        ]
    }
}