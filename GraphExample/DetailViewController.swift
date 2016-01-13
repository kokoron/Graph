//
//  DetailViewController.swift
//  GraphExample
//
//  Created by HiraiKokoro on 2015/11/24.
//  Copyright © 2015年 HiraiKokoro. All rights reserved.
//

import UIKit

import Graph

class DetailViewController: UIViewController {

    var detailItem: (String, [Graph<String, Int>], GraphViewAppearance)? {
        didSet {
            
        }
    }

    func configureView() {
        
        if let detailItem = self.detailItem {
            
            let view = GraphView(frame: self.view.bounds, graphs: detailItem.1, appearance: detailItem.2)
            self.view.addSubview(view)
            self.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

