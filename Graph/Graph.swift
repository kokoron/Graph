//
//  Graph.swift
//  Graph
//
//  Created by HiraiKokoro on 2015/11/25.
//
//

import UIKit

public enum Graph<T: Hashable, U: Numeric> {
    case
    BarGraph(GraphData<T, U>),
    LayeredBarGraph(GraphData<T, U>),
    MultipleBarGraph(GraphData<T, U>),
    LineGraph(GraphData<T, U>),
    PieChart(GraphData<T, U>)
    
    static public func barGraph(tuples: [(T, U)], minValue: U, maxValue: U, nameHandler: ((U) -> String?)? = nil, valueHandler: ((T) -> String?)? = nil) -> Graph<T, U> {
        return .BarGraph(
            GraphData(
                graphUnits: tuples.map{GraphUnit<T, U>(key: $0.0, value: [$0.1])},
                grapthParams: GraphParams(maximumValue: maxValue, minimumValue: minValue)
            )
        )
    }
    
    //    static public func pieChart(tuples: [(T, U)]) -> Graph<T, U> {
    //        return .PieChart(units(tuples))
    //    }
    
    
    public func view(frame: CGRect) -> GraphView<T, U> {
        return GraphView(frame: frame, graph: self)
    }
    
    static private func units(tuples: [(T, U)]) -> [GraphUnit<T, U>] {
        return tuples.map{GraphUnit(key: $0.0, value: [$0.1])}
    }
    
    
}

public struct GraphData<T: Hashable, U: Numeric> {
    
    internal typealias NameHandler = (T) -> String?
    internal typealias ValueHandler = (U) -> String?
    
    let graphUnits: [GraphUnit<T, U>]
    let grapthParams: GraphParams<U>
    private var nameHandler: NameHandler = {$0 as? String}
    private var valueHandler: ValueHandler = {(num) -> String? in
        if num is Float {
            return String(format: "%.2f", num as! Float)
        }
        else if num is Double {
            return String(format: "%.2f", num as! Double)
        }
        else if num is Int {
            return String(format: "%ld", num as! Int)
        }
        return nil
    }
    
    init(graphUnits: [GraphUnit<T, U>], grapthParams: GraphParams<U>, nameHandlerOrNil: (NameHandler)? = nil, valueHandlerOrNil: (ValueHandler)? = nil) {
        self.graphUnits = graphUnits
        self.grapthParams = grapthParams
        
        if let nameHandler = nameHandlerOrNil {
            self.nameHandler = nameHandler
        }
        
        if let valueHandler = valueHandlerOrNil {
            self.valueHandler = valueHandler
        }
    }
}

public struct GraphParams<T> {
    
    internal let maximumValue: T
    internal let minimumValue: T
    
}

public struct GraphUnit<T: Hashable, U: Numeric> {
    public let key: T
    public let value: [U]
    public init(key: T, value: [U]) {
        self.key = key
        self.value = value
    }
    
    public func rates(minValue: U, maxValue: U) -> [Float] {
        return self.value.map{self.rate($0, minValue: minValue, maxValue: maxValue)}
    }
    
    func rate(value: U, minValue: U, maxValue: U) -> Float {
        if maxValue is Float {
            return Float(value as? Float ?? 0.0) / (Float(maxValue as? Float ?? 0.0) - Float(minValue as? Float ?? 0.0))
        }
        else if maxValue is Double {
            return Float(value as? Double ?? 0.0) / (Float(maxValue as? Double ?? 0.0) - Float(minValue as? Double ?? 0.0))
        }
        else if maxValue is Int {
            return Float(value as? Int ?? 0) / (Float(maxValue as? Int ?? 0) - Float(minValue as? Int ?? 0))
        }
        return 0.0
    }
}

public protocol Numeric: Equatable {}
extension Float: Numeric {}
extension Double: Numeric {}
extension Int: Numeric {}

class NumberCruncher<C1: Numeric> {
    func echo(num: C1)-> C1 {
        return num
    }
}

extension Array {
    var match : (head: Element, tail: [Element])? {
        return (count > 0) ? (self[0],Array(self[1..<count])) : nil
    }
}
