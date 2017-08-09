//
//  ViewController.swift
//  XDSliderDemo
//
//  Created by chenyixing on 2017/8/4.
//  Copyright © 2017年 chenyixing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var sliderView :SliderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "标题"
        let one = OneviewController()
        let two = TwoviewController()
        let three = ThreeviewController()
        let four = FourviewController()
        
//        addChildViewController(one)
//        addChildViewController(two)
//        addChildViewController(three)
//        addChildViewController(four)
        
        let viewArr = [one.view,two.view,three.view,four.view]
        
        sliderView = SliderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), titles: ["1","2","3","4"], contentViews: viewArr as! [UIView])
        sliderView.selectedIndex = 0
        view.addSubview(sliderView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

