//
//  GraphView.swift
//  Graph
//
//  Created by HiraiKokoro on 2015/11/24.
//
//

import UIKit

public struct GraphViewAppearance {
    
    public static let defaultColors = [
        UIColor(red: 0.0, green: 181.0 / 255.0, blue: 187.0 / 255.0, alpha:  1.0)
    ]
    
    // MARK: - Colors
    public var colors: [UIColor] = GraphViewAppearance.defaultColors
    public var textColors: [UIColor] = GraphViewAppearance.defaultColors
    public var blankColor: UIColor = UIColor(white: 0.9, alpha: 1.0)
    
    // MARK: - Margin
    public var barWidthRatio: Float = 0.8
    public var dotDiameter: Float = 4.0
    
    // MARK: - Font
    public var font: UIFont = UIFont.systemFontOfSize(10.0)
    
    public init() {}
    
    public init(
        colors: [UIColor]?,
        textColors: [UIColor]?,
        blankColor: UIColor?,
        barWidthRatio: Float?,
        dotDiameter: Float?,
        font: UIFont?
    ) {
        
        if let colors = colors {
            self.colors = colors
        }
        
        if let textColors = textColors {
            self.textColors = textColors
        }
        
        if let blankColor = blankColor {
            self.blankColor = blankColor
        }
        
        if let barWidthRatio = barWidthRatio {
            self.barWidthRatio = barWidthRatio
        }
        
        if let dotDiameter = dotDiameter {
            self.dotDiameter = dotDiameter
        }
        
        if let font = font {
            self.font = font
        }
    }
}

public class GraphView<T: Hashable, U: Numeric>: UIView {
    
    var graphs: [Graph<T, U>] {
        get { return self._graphs }
        set(v) {
            self._graphs = v
            self.setup()
        }
    }
    
    var appearance: GraphViewAppearance {
        get { return self._appearance }
        set(v) {
            self._appearance = v
            self.setup()
        }
    }
    
    private var _graphs: [Graph<T, U>]
    private var _appearance: GraphViewAppearance
    
    public init(frame: CGRect, graphs: [Graph<T, U>], appearance: GraphViewAppearance = GraphViewAppearance()) {
        self._graphs = graphs
        self._appearance = appearance
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self._graphs.map{GraphLayerView(frame: self.bounds, graph: $0, appearance: self._appearance)}.forEach{v in
            self.addSubview(v)
            v.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        }
    }
}

class GraphLayerView<T: Hashable, U: Numeric>: UIView {
    
    private var graph: Graph<T, U>
    private var appearance: GraphViewAppearance

    init(frame: CGRect, graph: Graph<T, U>, appearance: GraphViewAppearance) {
        self.graph = graph
        self.appearance = appearance
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        setup()
    }

    private func setup() {
        
        self.subviews.forEach({$0.removeFromSuperview()})
        
        switch graph {
        case .BarGraph(let data):

            let views = data.graphUnits.map{BarGraphUnitView(frame: CGRectZero, graphUnit: $0, minValue: data.grapthParams.minimumValue, maxValue: data.grapthParams.maximumValue, blankColor: self.appearance.blankColor, barColors: self.appearance.colors, barWidthRatio: CGFloat(self.appearance.barWidthRatio))}
            let w = self.frame.size.width / CGFloat(views.count)
            for i in 0 ..< views.count {
                views[i].frame = CGRect(x: w * CGFloat(i), y: 0.0, width: w, height: self.frame.size.height)
            }
            views.forEach({self.addSubview($0)})
            views.forEach({$0.execute()})
            
        case .LineGraph(let data):
            
            let view = LineGraphView(frame: self.bounds, data: data, appearance: self.appearance)
            self.addSubview(view)
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
        case _:
            break
        }
        
    }
    
    
}
