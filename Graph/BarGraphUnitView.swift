//
//  BarGraphUnitView.swift
//  Graph
//
//  Created by HiraiKokoro on 2015/11/25.
//
//

import UIKit

class BarGraphUnitView<T: Hashable, U: Numeric>: UIView {
    
    private let graphUnit: GraphUnit<T, U>
    private let minValue: U
    private let maxValue: U
    private let barColors: [UIColor]
    
    private let barView: UIView = UIView()
    
    private lazy var bars: [UIView] = self.graphUnit.rates(self.minValue, maxValue: self.maxValue).map{CGRect(x: 0.0, y: self.frame.size.height - self.frame.size.height * CGFloat($0), width: self.frame.size.width, height: self.frame.size.height * CGFloat($0))}.map{UIView(frame: $0)}

    init(frame: CGRect, graphUnit: GraphUnit<T, U>, minValue: U, maxValue: U, blankColor: UIColor, barColors: [UIColor]) {
        self.graphUnit = graphUnit
        self.minValue = minValue
        self.maxValue = maxValue
        self.barColors = barColors
        super.init(frame: frame)
        
        self.backgroundColor = blankColor   
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func execute() {
        self.setBackgroundColors(self.bars, colors: self.barColors)
        self.bars.forEach({self.addSubview($0)})
    }
    
    
    private func setBackgroundColors(views: [UIView], colors: [UIColor]) {
        switch (views.match, colors.match) {
        case let (.Some(h, t), .Some(h2, t2)):
            h.backgroundColor = h2
            return self.setBackgroundColors(t, colors: t2)
        case _:
            break
        }
    }

}
