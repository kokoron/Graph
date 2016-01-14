//
//  Numeric+Graph.swift
//  Graph
//
//  Created by HiraiKokoro on 2016/01/14.
//
//

import Foundation

extension Int {
    
    public func formatDecimalString() -> String {
        
        let n = NSNumber(integer: self)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        return formatter.stringFromNumber(n)!
    }
}

extension Float {
    
    public func formatDecimalString() -> String {
        
        let n = NSNumber(float: self)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        return formatter.stringFromNumber(n)!
    }
}

extension Double {
    
    public func formatDecimalString() -> String {
        
        let n = NSNumber(double: self)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        return formatter.stringFromNumber(n)!
    }
}