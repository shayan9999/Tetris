//
//  Shape2D.swift
//  Tetris
//
//  Created by Shayan K. on 5/17/16.
//  Copyright © 2016 PiSociety. All rights reserved.
//

import Foundation


class Shape2D: Hashable, CustomStringConvertible{
    
    //MARK: - Constants
    
    let color: Color
    
    //MARK: - Variables
    
    var blocks = Array<Block2D>() //all blocks making this shape
    var orientation: Orientation  //orientation of this shape
    var column, row: Int          // row and column for this shape in the Board
    
    //MARK: Initializations
    
    init(column: Int, row: Int, color: Color, orientation: Orientation){
        self.color          = color;
        self.column         = column;
        self.row            = row;
        self.orientation    = orientation;
        self.initializeBlocks();
        
    }
    
    
    convenience init(column: Int, row: Int){
        self.init(column: column, row: row, color: Color.randomColor(), orientation: Orientation.randomOrientation())
    }
    
    final func initializeBlocks(){
        guard let blockPositionsPerOrientations = blockPositionsForOrientations[orientation] else{
            return
        }
        
        self.blocks = blockPositionsPerOrientations.map { (diff) -> Block2D in
                return Block2D(column: (column + diff.columnDiff), row: row + diff.rowDiff, color: color)
        }
    }
    
    //MARK: - Shape Interactions
    
    
    //MARK: - Required Override methods
    
    // this represents all blocks difference in x and y - rows and columns from 
    // the main center point of shape
    var blockPositionsForOrientations: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>]{
        return [:]
    }
    
    // this will be helpful in determining when this shape touches the bottom or any other shape
    var bottomBlocksForOrientations: [Orientation: Array<Block2D>]{
        return [:]
    }
    
    
    var bottomBlocks: Array<Block2D> {
        guard let bottomBlocks = bottomBlocksForOrientations[self.orientation] else{
                return []
        }
        
        return bottomBlocks
    }
    
    
    //MARK: - Protocol Implementations
    var hashValue: Int{
        return blocks.reduce(0) {
            $0.hashValue ^ $1.hashValue
        }
    }
    
    var description: String{
        return "\(color) block with orientation: \(blocks[0]), \(blocks[1]), \(blocks[2]), \(blocks[3])"
    }
}