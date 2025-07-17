//
//  ArrayDoubleExtensions.swift
//  RosaKit
//
//  Created by Hrebeniuk Dmytro on 17.12.2019.
//  Copyright © 2019 Dmytro Hrebeniuk. All rights reserved.
//

import Foundation

extension Array where Iterator.Element: FloatingPoint {
    
    var diff: [Element] {
        var diff = [Element]()
        
        for index in 1..<self.count {
            let value = self[index]-self[index-1]
            diff.append(value)
        }
        
        return diff
    }
    
    func outerSubstract(array: [Element]) -> [[Element]] {
        var result = [[Element]]()
        
        let rows = self.count
        let cols = array.count
        
        for row in 0..<rows {
            var rowValues = [Element]()
            for col in 0..<cols {
                let value = self[row] - array[col]
                rowValues.append(value)
            }
            
            result.append(rowValues)
        }
        
        return result
    }
    
}

extension Array where Iterator.Element == Double {
            
    func frame(frameLength: Int = 2048, hopLength: Int = 512) -> [[Element]] {
        let outputShape = (width: self.count - frameLength + 1, height: frameLength)
                
        let verticalSize = Int(ceil(Float(outputShape.width)/Float(hopLength)))
              
        var xw = [[Double]]()
        
        for yIndex in 0..<verticalSize {
            var lineArray = [Double]()

            for xIndex in 0..<frameLength {
                let value = self[((yIndex*hopLength)+xIndex)%self.count]
                
                lineArray.append(value)
            }
            xw.append(lineArray)
        }
        
        return xw.transposed
    }
                                       
}
