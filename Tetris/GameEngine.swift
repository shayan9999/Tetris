//
//  GameEngine.swift
//  Tetris
//
//  Created by Shayan K. on 5/17/16.
//  Copyright © 2016 PiSociety. All rights reserved.
//

import Foundation


protocol GameDelegate {
    // Invoked when the current round ends
    func gameDidEnd(game: GameEngine)
    
    // Invoked after a new game has begun
    func gameDidBegin(game: GameEngine)
    
    // Invoked when the falling shape has become part of the game board
    func gameShapeDidLand(game: GameEngine)
    
    // Invoked when the falling shape has changed its location
    func gameShapeDidMove(game: GameEngine)
    
    // Invoked when the falling shape has changed its location after being dropped
    func gameShapeDidDrop(game: GameEngine)
    
    // Invoked when the game has reached a new level
    func gameDidLevelUp(game: GameEngine)
}

class GameEngine {
    
    //MARK: - Constants
    let PreviewColumn = 12
    let PreviewRow = 1
    
    //MARK: - Variables
    var blockArray:     TetrisBoard<Block2D>
    var nextShape:      Shape2D?
    var fallingShape:   Shape2D?
    var delegate: GameDelegate?
    var score           = 0
    var level           = 1
    
    //MARK: - Initializations
    init() {
        fallingShape = nil
        nextShape = nil
        blockArray = TetrisBoard<Block2D>(columns: totalTetrisColumns, rows: totalTetrisRows)
    }
    
    //MARK: - Game Controls
    func beginGame() {
        if (nextShape == nil) {
            nextShape = Shape2D.randomShape(PreviewColumn, startingRow: PreviewRow)
        }
        delegate?.gameDidBegin(self)
    }
    
    func newShape() -> (fallingShape:Shape2D?, nextShape:Shape2D?) {
        fallingShape = nextShape
        nextShape = Shape2D.randomShape(PreviewColumn, startingRow: PreviewRow)
        fallingShape?.moveTo(tetrisStartingColumn, row: tetrisStartingRow)
        
        guard detectIllegalPlacement() == false else {
            nextShape = fallingShape
            nextShape!.moveTo(PreviewColumn, row: PreviewRow)
            endGame()
            return (nil, nil)
        }
        
        return (fallingShape, nextShape)
    }
    
    func removeAllBlocks() -> Array<Array<Block2D>> {
        var allBlocks = Array<Array<Block2D>>()
        for row in 0..<totalTetrisRows {
            
            var rowOfBlocks = Array<Block2D>()
            
            for column in 0..<totalTetrisColumns {
                guard let block = blockArray[column, row] else {
                    continue
                }
                rowOfBlocks.append(block)
                blockArray[column, row] = nil
                block.sprite?.removeFromParent()
            }
            
            allBlocks.append(rowOfBlocks)
        }
        return allBlocks
    }

    
    // MARK: - Check State
    func detectIllegalPlacement() -> Bool {
        
        // check if the falling shape is set
        guard let shape = fallingShape else {
            return false
        }
        
        // for each block in the shape, check if it goes out of bounds
        for block in shape.blocks {
            if block.column < 0 || block.column >= totalTetrisColumns
                || block.row < 0 || block.row >= totalTetrisRows {
                return true
            } else if blockArray[block.column, block.row] != nil {
                return true
            }
        }
        return false
    }
    
    func detectTouch() -> Bool {
        guard let shape = fallingShape else {
            return false
        }
        for bottomBlock in shape.bottomBlocks {
            if bottomBlock.row == totalTetrisRows - 1
                || blockArray[bottomBlock.column, bottomBlock.row + 1] != nil {
                return true
            }
        }
        return false
    }
    
    func endGame() {
        removeAllBlocks();
        delegate?.gameDidEnd(self)
        score = 0
        level = 1
    }
    
    //MARK: - Game Scoring
    
    func getCompletedLines() -> (linesRemoved: Array<Array<Block2D>>, fallenBlocks: Array<Array<Block2D>>) {
        
        // look through all the columns and find a row which has all columns filled
        var completedLines = Array<Array<Block2D>>()
        for row in (1..<totalTetrisRows).reverse() {
            var rowOfBlocks = Array<Block2D>()

            for column in 0..<totalTetrisColumns {
                guard let block = blockArray[column, row] else {
                    continue
                }
                rowOfBlocks.append(block)
            }
            if rowOfBlocks.count == totalTetrisColumns {
                completedLines.append(rowOfBlocks)
                for block in rowOfBlocks {
                    blockArray[block.column, block.row] = nil
                }
            }
        }
        
        // No lines completed return empty arrays tuple
        if completedLines.count == 0 {
            return ([], [])
        }

        
        //TODO: scoring here + level up when functionality is added
        //let pointsEarned = completedLines.count * PointsPerLine * level
        //score += pointsEarned
        //if score >= level * LevelThreshold {
            //level += 1
            //delegate?.gameDidLevelUp(self)
        //}
        
        // Find blocks that will fall down because of removal of a line of blocks now
        var fallenBlocks = Array<Array<Block2D>>()
        
        for column in 0..<totalTetrisColumns {
            var fallenBlocksArray = Array<Block2D>()
            
            // start from bottom
            for row in (1..<completedLines[0][0].row).reverse() {
                guard let block = blockArray[column, row] else {
                    continue
                }
                var newRow = row
                while (newRow < totalTetrisRows - 1 && blockArray[column, newRow + 1] == nil) {
                    newRow += 1
                }
                block.row = newRow
                blockArray[column, row] = nil // there cant be anything new coming down so set it to nil
                blockArray[column, newRow] = block
                fallenBlocksArray.append(block)
            }
            if fallenBlocksArray.count > 0 {
                fallenBlocks.append(fallenBlocksArray)
            }
        }
        return (completedLines, fallenBlocks)
    }
        
    //MARK: - Game Movements
    
    // used to drop the shape to the bottom
    func dropCurrentShape() {
        guard let shape = fallingShape else {
            return
        }
        while detectIllegalPlacement() == false {
            shape.lowerShapeByOneRow()
        }
        shape.raiseShapeByOneRow()
        delegate?.gameShapeDidDrop(self)
    }
    
    // this will be called in every frame. The shape on screen falls on row every tick
    func letCurrentShapeFall() {
        guard let shape = fallingShape else {
            return
        }
        shape.lowerShapeByOneRow()
        if detectIllegalPlacement() {
            shape.raiseShapeByOneRow()
            if detectIllegalPlacement() {
                endGame()
            } else {
                settleCurrentShape()
            }
        } else {
            delegate?.gameShapeDidMove(self)
            if detectTouch() {
                settleCurrentShape()
            }
        }
    }
    
    func rotateCurrentShape() {
        guard let shape = fallingShape else {
            return
        }
        shape.rotateClockwise()
        guard detectIllegalPlacement() == false else {
            shape.rotateCounterClockwise()
            return
        }
        delegate?.gameShapeDidMove(self)
    }
    
    func moveCurrentShapeLeft() {
        guard let shape = fallingShape else {
            return
        }
        shape.shiftLeftByOneColumn()
        guard detectIllegalPlacement() == false else {
            shape.shiftRightByOneColumn()
            return
        }
        delegate?.gameShapeDidMove(self)
    }
    
    func moveCurrentShapeRight() {
        guard let shape = fallingShape else {
            return
        }
        shape.shiftRightByOneColumn()
        guard detectIllegalPlacement() == false else {
            shape.shiftLeftByOneColumn()
            return
        }
        delegate?.gameShapeDidMove(self)
    }
    
    func settleCurrentShape() {
        guard let shape = fallingShape else {
            return
        }
        for block in shape.blocks {
            blockArray[block.column, block.row] = block
        }
        fallingShape = nil
        delegate?.gameShapeDidLand(self)
    }
}