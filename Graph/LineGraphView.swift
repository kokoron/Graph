//
//  LineGraphView.swift
//  Graph
//
//  Created by HiraiKokoro on 2015/11/30.
//
//

import UIKit

class LineGraphView<T: Hashable, U: Numeric>: UIView {

    private var data: GraphData<T, U>
    private var appearance: GraphViewAppearance
    
    private lazy var values: [[U]] = self.changeValues(self.data.graphUnits.map({$0.value}))
    
    private lazy var rates: [[Float]] = self.values.map({$0.map({self.rate($0, minValue: self.data.grapthParams.minimumValue, maxValue: self.data.grapthParams.maximumValue)})})
    
    private lazy var points: [[CGPoint]] = self.makePoints(self.rates)
    
    private lazy var labels: [UILabel] = Array(zip(self.points.first!, self.values.first!)).map{(p, v) -> UILabel in
        let w: CGFloat = 50.0
        let label = UILabel(frame: CGRect(
            origin: CGPoint(
                x: p.x - (w / 2.0),
                y: p.y - 30.0
            ),
            size: CGSize(width: w, height: 20.0)))
        label.textAlignment = NSTextAlignment.Center
        label.textColor = self.appearance.lineValueColors.first
        label.font = UIFont.systemFontOfSize(10.0)
        label.text = v.formatDecimalString()
        return label
    }
    
    init(frame: CGRect, data: GraphData<T, U>, appearance: GraphViewAppearance) {
        self.data = data
        self.appearance = appearance
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = false
    }
    
    private func changeValues(values: [[U]]) -> [[U]] {
        var array = [[U]]()
        
        guard let count = values.map({$0.count}).sort({$0 <= $1}).first else {
            return array
        }
        for _ in 0 ..< count {
            array.append([U]())
        }
        values.forEach({u in
            for i in 0 ..< count {
                array[i].append(u[i])
            }
        })
        return array
    }
    
    private func rate(value: U, minValue: U, maxValue: U) -> Float {
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
    
    private func makePoints(rates: [[Float]]) -> [[CGPoint]] {
        let h = self.frame.size.height - 20.0
        let ys = rates.map({$0.map({h - h * CGFloat($0)})})
        let w = self.frame.size.width / CGFloat(self.data.graphUnits.count)
        var array = [[CGPoint]]()
        for yss in ys {
            var array2 = [CGPoint]()
            for i in 0 ..< yss.count {
                array2.append(CGPoint(x: CGFloat(i) * w + w / 2.0, y: yss[i]))
            }
            array.append(array2)
        }
        return array
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let size = 10.0

        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, self.appearance.lineColor.first?.CGColor ?? UIColor.blackColor().CGColor)
        CGContextSetLineWidth(context, 3.0)
        
        self.points.forEach({points in
            points.forEach({point in
                if point == points.first {
                    CGContextMoveToPoint(context, point.x, point.y)
                }
                else {
                    CGContextAddLineToPoint(context, point.x, point.y)
                    CGContextStrokePath(context)
                    CGContextMoveToPoint(context, point.x, point.y)
                }
            })
        })
        
        CGContextSetFillColorWithColor(context, self.appearance.lineColor.first?.CGColor ?? UIColor.blackColor().CGColor)
        
        self.points.forEach({points in
            points.forEach({point in
                let r = CGRect(x: point.x - CGFloat(size / 2.0), y: point.y - CGFloat(size / 2.0), width: CGFloat(size), height: CGFloat(size))
                CGContextStrokeEllipseInRect(context, r)
                CGContextFillEllipseInRect(context, r)
            })
        })
        
        self.labels.forEach { (l) -> () in
            l.removeFromSuperview()
            self.addSubview(l)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }

}
