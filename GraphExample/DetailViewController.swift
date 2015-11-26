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

    var detailItem: Graph<String, Int>? {
        didSet {
            
        }
    }

    func configureView() {
        
        if let view = self.detailItem?.view(self.view.frame) {
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

