//
//  NavigationController.swift
//  XDSliderDemo
//
//  Created by chenyixing on 2017/8/4.
//  Copyright © 2017年 chenyixing. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置导航栏样式
        
        navigationBar.barStyle = .default
//        navigationBar.setBackgroundImage(creatImageWithColor(color: UIColor.white), for: .default)
        navigationBar.isTranslucent = false
//        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.barTintColor = UIColor.white
//        navigationBar.shadowImage = UIImage()
//        UINavigationBar.appearance()
        // 标题样式
        let bar = UINavigationBar.appearance()
        bar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.black,
            NSFontAttributeName : UIFont.systemFont(ofSize: 19)
        ]
        
    }
    
    func creatImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
