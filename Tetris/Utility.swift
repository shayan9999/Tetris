//
//  Utility.swift
//  Tetris
//
//  Created by Shayan K. on 5/18/16.
//  Copyright © 2016 PiSociety. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

// This class has all game utility functions
class Utility{
    
    // Singleton specifier
    class var sharedInstance: Utility {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Utility? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Utility()
        }
        return Static.instance!
    }
    
}