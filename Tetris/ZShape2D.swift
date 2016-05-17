//
//  ZShape2D.swift
//  Tetris
//
//  Created by Shayan K. on 5/17/16.
//  Copyright © 2016 PiSociety. All rights reserved.
//

import Foundation


class ZShape2D :Shape2D {
    /*
     
     Orientation 0
     
     • | 0 |
     | 2 | 1 |
     | 3 |
     
     Orientation 90
     
     | 0 | 1•|
     | 2 | 3 |
     
     Orientation 180
     
     • | 0 |
     | 2 | 1 |
     | 3 |
     
     Orientation 270
     
     | 0 | 1•|
     | 2 | 3 |
     
     
     • marks the row/column indicator for the shape
     
     */
    
    override var blockPositionsForOrientations: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Up:         [(1, 0), (1, 1), (0, 1), (0, 2)],
            Orientation.Right:      [(-1,0), (0, 0), (0, 1), (1, 1)],
            Orientation.Down:       [(1, 0), (1, 1), (0, 1), (0, 2)],
            Orientation.Left:       [(-1,0), (0, 0), (0, 1), (1, 1)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block2D>] {
        return [
            Orientation.Up:         [blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Right:      [blocks[FirstBlockIdx], blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Down:       [blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Left:       [blocks[FirstBlockIdx], blocks[ThirdBlockIdx], blocks[FourthBlockIdx]]
        ]
    }
}
