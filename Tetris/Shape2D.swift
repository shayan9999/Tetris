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
    
    // initializes information about the blocks available in this shape
    // this is particularly information on where with respect to the center block, every other block is placed
    final func initializeBlocks(){
        guard let blockPositionsPerOrientations = blockPositionsForOrientations[orientation] else{
            return
        }
        
        self.blocks = blockPositionsPerOrientations.map { (diff) -> Block2D in
                return Block2D(column: (column + diff.columnDiff), row: row + diff.rowDiff, color: color)
        }
    }
    
    
    final class func randomShape(startingColumn:Int, startingRow:Int) -> Shape2D {
        switch Int(arc4random_uniform(totalShapes)) {

            case 0:
                return Square2D(column:startingColumn, row:startingRow)
            case 1:
                return Line2D(column:startingColumn, row:startingRow)
            case 2:
                return TShape2D(column:startingColumn, row:startingRow)
            case 3:
                return LShape2D(column:startingColumn, row:startingRow)
            case 4:
                return JShape2D(column:startingColumn, row:startingRow)
            case 5:
                return SShape2D(column:startingColumn, row:startingRow)
            default:
                return ZShape2D(column:startingColumn, row:startingRow)
        }
    }
    
    //MARK: - Shape Movements
    
    final func rotateClockwise() {
        let newOrientation = Orientation.rotate(orientation, clockwise: true)
        rotateBlocks(newOrientation)
        orientation = newOrientation
    }
    
    final func rotateCounterClockwise() {
        let newOrientation = Orientation.rotate(orientation, clockwise: false)
        rotateBlocks(newOrientation)
        orientation = newOrientation
    }
    
    final func rotateBlocks(orientation: Orientation) {
        
        // get information about the orientation for this particular shape
        guard let blockRowColumnTranslation: Array<(columnDiff: Int, rowDiff: Int)> =
            blockPositionsForOrientations[orientation] else {
            return
        }
        
        // Update information about all 4 blocks in our shape based on the orientation that was applied
        for (index, diff) in blockRowColumnTranslation.enumerate() {
            blocks[index].column    = column + diff.columnDiff
            blocks[index].row       = row + diff.rowDiff
        }
    }
    
    final func lowerShapeByOneRow() {
        self.shiftBy(0, rows: 1)
    }
    
    final func raiseShapeByOneRow() {
        self.shiftBy(0, rows: -1)
    }
    
    final func shiftRightByOneColumn() {
        self.shiftBy(1, rows: 0)
    }
    
    final func shiftLeftByOneColumn() {
        self.shiftBy(-1, rows: 0)
    }
    
    // moves the shape one unit downwards
    final func moveDown(){
        self.shiftBy(0, rows: 1)
    }
    
    // moves the shape based on number of columns and rows its given
    final func shiftBy(columns: Int, rows: Int){
        self.column = self.column + columns;
        self.row    = self.row    + rows;
        
        for block in self.blocks {
            block.column = block.column + columns;
            block.row    = block.row    + rows;
        }
        print("Shape now at: [\(row), \(column)]")
    }
    
    // added later because we need this method to readjust shapes positioning when they move away due to rotation
    final func moveTo(column: Int, row: Int){
        self.column = column;
        self.row    = row;
        self.rotateBlocks(self.orientation);
    }
    
    
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
    
    // contains all the bottom blocks in this shape. These blocks will help in finding collision etc
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