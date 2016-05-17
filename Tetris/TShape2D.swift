//
//  TShape2D.swift
//  Tetris
//
//  Created by Shayan K. on 5/17/16.
//  Copyright © 2016 PiSociety. All rights reserved.
//

import Foundation

class TShape2D :Shape2D {
    /*
     Orientation 0
     
     • | 0 |
     | 1 | 2 | 3 |
     
     Orientation 90
     
     • | 1 |
     | 2 | 0 |
     | 3 |
     
     Orientation 180
     
     •
     | 1 | 2 | 3 |
     | 0 |
     
     Orientation 270
     
     • | 1 |
     | 0 | 2 |
     | 3 |
     
     • marks the row/column indicator for the shape
     
     */
    
    override var blockPositionsForOrientations: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]
    {
        return [
            Orientation.Up:         [(1, 0), (0, 1), (1, 1), (2, 1)],
            Orientation.Right:      [(2, 1), (1, 0), (1, 1), (1, 2)],
            Orientation.Down:       [(1, 2), (0, 1), (1, 1), (2, 1)],
            Orientation.Left:       [(0, 1), (1, 0), (1, 1), (1, 2)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block2D>] {
        return [
            Orientation.Up:         [blocks[SecondBlockIdx], blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Right:      [blocks[FirstBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Down:       [blocks[FirstBlockIdx], blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Left:       [blocks[FirstBlockIdx], blocks[FourthBlockIdx]]
        ]
    }
}