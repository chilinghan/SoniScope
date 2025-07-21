//
//  ArrayExtensions.swift
//  RosaKit
//
//  Created by Hrebeniuk Dmytro on 15.12.2019.
//  Copyright © 2019 Dmytro Hrebeniuk. All rights reserved.
//

import Foundation

extension Array where Iterator.Element: FloatingPoint {
    
    static func empty(width: Int, height: Int, defaultValue: Element) -> [[Element]] {
        var result: [[Element]] = [[Element]]()
        
        for _ in 0..<width {
            var vertialArray: [Element] = [Element]()
            for _ in 0..<height {
                vertialArray.append(defaultValue)
            }
            result.append(vertialArray)
        }
        
        return result
    }
    
    func reflectPad(fftSize: Int) -> [Element] {
        var array = [Element]()
        
        array.append(contentsOf: [Element].init(repeating: Element(0), count: fftSize/2))
        array.append(contentsOf: self)
        array.append(contentsOf: [Element].init(repeating: Element(0), count: fftSize/2))

        return array
    }
 
    static func linespace(start: Element, stop: Element, num: Element) -> [Element] {
        var linespace = [Element]()
    
        let one = num/num
        var index = num*0
        while index < num-one {
            let startPart = (start*(one - index/floor(num - one)))
            let stopPart = (index*stop/floor(num - one))

            let value = startPart + stopPart

            linespace.append(value)
            index += num/num
        }
        
        linespace.append(stop)
                
        return linespace
    }
    


}

extension Array where Iterator.Element == Double {
    
    static func getHannWindow(frameLength: Int) -> [Double] {
        let fac = [Double].linespace(start: -Double.pi, stop: Double.pi, num: Double(frameLength + 1))

        var w = [Double](repeating: 0.0, count: frameLength+1)
        
        for (k, a) in [0.5, 0.5].enumerated(){
            for index in 0..<w.count {
                w[index] += a*cos(Double(k)*fac[index])
            }
        }

        return Array(w[0..<w.count-1])
    }
    
}
