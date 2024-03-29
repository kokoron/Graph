//
//  BarGraphUnitView.swift
//  Graph
//
//  Created by HiraiKokoro on 2015/11/25.
//
//

import UIKit

class BarView: UIView {
    private let param: Float
    
    init(frame: CGRect, param: Float) {
        self.param = param
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BarGraphUnitView<T: Hashable, U: Numeric>: UIView {
    
    private let graphUnit: GraphUnit<T, U>
    private let minValue: U
    private let maxValue: U
    private let barColors: [UIColor]
    private let valueColors: [UIColor]
    private let blankColor: UIColor
    private let barWidthRatio: CGFloat
    
    
    private lazy var bars: [BarView] = self.graphUnit.rates(self.minValue, maxValue: self.maxValue).map{(rate) -> (CGRect, Float) in
        let h = self.frame.size.height - 20.0
        return (CGRect(x: 0.0, y: h - h * CGFloat(rate), width: self.frame.size.width, height: h * CGFloat(rate)), rate)
    }.map{BarView(frame: $0, param: $1)}.map{(v) -> BarView in
        v.transform = CGAffineTransformMakeScale(CGFloat(self.barWidthRatio), 1.0)
        return v
    }
    
    private lazy var labels: [UILabel] = Array(zip(self.bars, self.graphUnit.value)).map{(b, v) -> UILabel in
        let label = UILabel(frame: CGRect(origin: CGPoint(x: b.frame.origin.x, y: b.frame.origin.y - 20.0), size: CGSize(width: b.frame.size.width, height: 20.0)))
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(10.0)
        label.text = v.formatDecimalString()
        return label
    }
    
    

    init(
        frame: CGRect,
        graphUnit: GraphUnit<T, U>,
        minValue: U,
        maxValue: U,
        blankColor: UIColor,
        barColors: [UIColor],
        valueColors: [UIColor],
        barWidthRatio: CGFloat
    ) {
        self.graphUnit = graphUnit
        self.minValue = minValue
        self.maxValue = maxValue
        self.barColors = barColors
        self.valueColors = valueColors
        self.blankColor = blankColor
        self.barWidthRatio = barWidthRatio
        super.init(frame: frame)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func execute() {
        
        self.backgroundColor = UIColor.clearColor()
        let blankView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height - 20.0)))
        blankView.transform = CGAffineTransformMakeScale(CGFloat(self.barWidthRatio), 1.0)
        blankView.backgroundColor = self.blankColor
        self.addSubview(blankView)
        blankView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let label = UILabel(
            frame: CGRect(
                origin: CGPoint(x: 0.0, y: self.frame.size.height - 20.0),
                size: CGSize(width: self.frame.size.width, height: 20.0)
            )
        )
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(10.0)
        label.text = String(self.graphUnit.key)
        self.addSubview(label)
        
        self.setBackgroundColors(self.bars, colors: self.barColors)
        self.setLabelsColors(self.labels, colors: self.valueColors)
        self.bars.forEach({self.addSubview($0)})
        self.labels.forEach{self.addSubview($0)}
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
    
    private func setLabelsColors(labels: [UILabel], colors: [UIColor]) {
        switch (labels.match, colors.match) {
        case let (.Some(h, t), .Some(h2, t2)):
            h.textColor = h2
            self.setLabelsColors(t, colors: t2)
        case _:
            break
        }
    }

}
