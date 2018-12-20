//
//  ColorGenerator.swift
//  GraphColoring
//
//  Created by farhad jebelli on 12/15/18.
//  Copyright © 2018 farhad jebelli. All rights reserved.
//

import Cocoa

class ColorGenerator {
    
    private var offset: Int = 80
    
    private var index: Int = 0
    
    private var redIndex: Int = 0
    private var blueIndex: Int = 0
    private var greenIndex: Int = 0
    
    func nextColor() -> NSColor {
        setGreen(value: greenIndex + offset)
        return NSColor(red: CGFloat(redIndex)/255.0, green: CGFloat(greenIndex)/255.0, blue: CGFloat(blueIndex)/255.0, alpha: 1)
        
    }
    
    private func setGreen(value: Int) {
        if value > 255 {
            greenIndex = value % 255
            setBlue(value: blueIndex + offset)
        } else {
            greenIndex = value
        }
        
    }
    private func setBlue(value: Int) {
        if value > 255 {
            blueIndex = value % 255
            setRed(value: redIndex + offset)
        } else {
            blueIndex = value
        }
        
    }
    private func setRed(value: Int) {
        if value > 255 {
            redIndex = value % 255
            setGreen(value: greenIndex + offset)
        } else {
            redIndex = value
        }
    }
    
    
    
}
