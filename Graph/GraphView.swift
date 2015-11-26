//
//  GraphView.swift
//  Graph
//
//  Created by HiraiKokoro on 2015/11/24.
//
//

import UIKit

public struct GraphViewAppearance {
    
    static let defaultColors = [UIColor(red: 0.0, green: 181.0 / 255.0, blue: 187.0 / 255.0, alpha:  1.0)]
    
    // MARK: - Colors
    let colors: [UIColor] = GraphViewAppearance.defaultColors
    let textColors: [UIColor] = GraphViewAppearance.defaultColors
    let blankColor: UIColor = UIColor(white: 0.9, alpha: 1.0)
    
    // MARK: - Margin
    let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
    let clearance: CGFloat = 8.0
    
    // MARK: - Font
    let font: UIFont = UIFont.systemFontOfSize(10.0)
}

public class GraphView<T: Hashable, U: Numeric>: UIView {
    
    var graph: Graph<T, U>? {
        get { return self._graph }
        set(v) {
            self._graph = v
            self.setup()
        }
    }
    
    private var _graph: Graph<T, U>?

    init(frame: CGRect, graph: Graph<T, U>) {
        self._graph = graph
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
    
    private func setup() {
        
        self.subviews.forEach({$0.removeFromSuperview()})
        
        guard let graph = self._graph else {
            return
        }
        
        switch graph {
        case .BarGraph(let data):

            let views = data.graphUnits.map{BarGraphUnitView(frame: CGRectZero, graphUnit: $0, minValue: data.grapthParams.minimumValue, maxValue: data.grapthParams.maximumValue, blankColor: UIColor.blackColor(), barColors: [UIColor.lightGrayColor(), UIColor.grayColor(), UIColor.darkGrayColor()])}
            let w = self.frame.size.width / CGFloat(views.count)
            for i in 0 ..< views.count {
                views[i].frame = CGRect(x: w * CGFloat(i), y: 0.0, width: w, height: self.frame.size.height)
            }
            views.forEach({self.addSubview($0)})
            views.forEach({$0.execute()})
            
        case _:
            break
        }
        
    }
    
    
}
