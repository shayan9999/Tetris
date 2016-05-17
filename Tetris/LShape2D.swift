//
//  LShape2D.swift
//  Tetris
//
//  Created by Shayan K. on 5/17/16.
//  Copyright © 2016 PiSociety. All rights reserved.
//

import Foundation

class LShape2D: Shape2D {
    /*
     
     Orientation 0
     
     | 0•|
     | 1 |
     | 2 | 3 |
     
     Orientation 90
     
     •
     | 2 | 1 | 0 |
     | 3 |
     
     Orientation 180
     
     | 3 | 2•|
     | 1 |
     | 0 |
     
     Orientation 270
     
     • | 3 |
     | 0 | 1 | 2 |
     
     • marks the row/column indicator for the shape
     
     Pivots about `1`
     
     */
    
    override var blockPositionsForOrientations: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        return [
            Orientation.Up:         [ (0, 0), (0, 1),  (0, 2),  (1, 2)],
            Orientation.Right:      [ (1, 1), (0, 1),  (-1,1), (-1, 2)],
            Orientation.Down:       [ (0, 2), (0, 1),  (0, 0),  (-1,0)],
            Orientation.Left:       [ (-1,1), (0, 1),  (1, 1),   (1,0)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block2D>] {
        return [
            Orientation.Up:         [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Right:      [blocks[FirstBlockIdx], blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Down:       [blocks[FirstBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Left:       [blocks[FirstBlockIdx], blocks[SecondBlockIdx], blocks[ThirdBlockIdx]]
        ]
    }
}