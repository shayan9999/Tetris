//
//  Line2D.swift
//  Tetris
//
//  Created by Shayan K. on 5/17/16.
//  Copyright © 2016 PiSociety. All rights reserved.
//

import Foundation

class Line2D :Shape2D {
    /*
     Orientations 0 and 180:
     
     | 0•|
     | 1 |
     | 2 |
     | 3 |
     
     Orientations 90 and 270:
     
     | 0 | 1•| 2 | 3 |
     
     • marks the row/column indicator for the shape
     
     */
    
    // Hinges about the second block
    
    override var blockPositionsForOrientations: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>]{
        return [
            Orientation.Up:       [(0, 0), (0, 1), (0, 2), (0, 3)],
            Orientation.Right:     [(-1,0), (0, 0), (1, 0), (2, 0)],
            Orientation.Down:  [(0, 0), (0, 1), (0, 2), (0, 3)],
            Orientation.Left: [(-1,0), (0, 0), (1, 0), (2, 0)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block2D>] {
        return [
            Orientation.Up:         [blocks[FourthBlockIdx]],
            Orientation.Right:      blocks,
            Orientation.Down:       [blocks[FourthBlockIdx]],
            Orientation.Left:       blocks
        ]
    }
}