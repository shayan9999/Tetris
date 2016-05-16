//
//  2DTetrisBoard.swift
//  Tetris
//
//  Created by Shayan K. on 5/16/16.
//  Copyright © 2016 PiSociety. All rights reserved.
//

import Foundation

class TetrisBoard2D<T>{
    
    // rows and columns size of this board
    let columns: Int
    let rows: Int
    
    // the array that holds all the items in a 1D array, we can use our own technique 
    // to index these values based on row and column
    var allItems: Array<T?>
    
    
    init(columns: Int, rows: Int){
        self.columns    = columns
        self.rows       = rows;
        
        allItems = Array<T?> (count: rows * columns, repeatedValue: nil)
    }
    
    
    // Getter and setter method for this 2D Board
    func getItem(row: Int, column: Int) -> T? {
        return allItems[(rows * column) + row]
    }
    
    func setItem(row: Int, column: Int, anyItem: T?){
        allItems[(rows * column) + row] = anyItem
    }
    
    // instead we can define subscript just like for tuples to access this 2D data class
    subscript(column: Int, row: Int) -> T?{
        
        get{
            return allItems[ (rows * column) + row]
        }
        
        set(newValue){
            allItems [(rows * column) + row] = newValue
        }
        
    }
}