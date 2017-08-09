//
//  SliderView.swift
//  XDSliderDemo
//
//  Created by chenyixing on 2017/8/4.
//  Copyright © 2017年 chenyixing. All rights reserved.
//

import UIKit

class SliderView: UIView ,UIScrollViewDelegate{

    
    public var selectedIndex = 0{
        didSet{
            if self.subviews.count > 0 {
                assert(selectedIndex < subViewCount , "下标越界！子视图并没有这么多")
                changeView()
            }
        
        }
    }
    
    public var topViewHeight = 50;
    public var btnFontSize: CGFloat = 17
    public var btnFontColorNormal = UIColor.black
    public var btnFontColorSelected = UIColor.MainColor
    public var lineColor = UIColor.LineColor
    public var lineSize: CGFloat = 1
    public var sliderColor = UIColor.MainColor
    public var sliderHeight :CGFloat = 2
    public var sliderWidth : CGFloat = 0

    
    /// 是否允许手动滑动滚动
    public var isAllowHandleScroll = true
    /// 是否使用弹簧效果
    public var isBounces = false
    /// 是否显示点击按钮缩放动画
    public var isShowBtnAnimation = true
    /// 是否显示按钮间的竖直分割线
    public var isShowVerticalLine = true
    /// 是否显示按钮底部的水平分割线
    public var isShowHorizontalLine = true
    
    
    private var titles = [String]()
    private var contentViews = [UIView]()
    private var subViewCount = 0 // 自视图个数
    private var BaseTag = 1000
    private var selectedBtn = UIButton() // 当前被选中的按钮
    private var topView = UIView() // 头部标题按钮视图
    private var sliderView =  UIView() // 底部滑条
    private var scrollView = RecognizerScrollView() // 滚动视图
    
    convenience  init(frame: CGRect,titles:[String],contentViews:[UIView]) {
        self.init(frame: frame)
        self.titles = titles;
        self.contentViews = contentViews
        subViewCount = titles.count
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        makeUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func makeUI() {
        // 顶部视图
        maketopView()
        
        // 子视图
        addContentView()
    }
    // 标题按钮视图
    private func maketopView() {
        
        topView.frame = CGRect(x: 0, y: 0, width: Int(self.width), height: topViewHeight)
        topView.backgroundColor = UIColor.white
        self.addSubview(topView)
        
        // 标题按钮
        let btnW = topView.width / CGFloat(subViewCount)
        let btnH = topView.height
        for i in 0 ..< subViewCount {
            let btnX = CGFloat(i) * btnW
            let button = UIButton(frame: CGRect(x: btnX, y: 0, width: btnW, height: btnH))
            button.setTitle(titles[i], for: .normal)
            button.setTitleColor(btnFontColorNormal, for: .normal)
            button.setTitleColor(btnFontColorSelected, for: .disabled)
            button.titleLabel?.font = UIFont.systemFont(ofSize: btnFontSize)
            button.tag = i + BaseTag
            button.addTarget(self, action: #selector(titleBtnClicked(btn:)), for: .touchUpInside)
            topView.addSubview(button)
            
            if i == selectedIndex { // 默认选中第一个按钮
                button.isEnabled = false
                selectedBtn = button
            }
            
            // 按钮之间竖直分割线
            if isShowVerticalLine {
                let lineView = UIView(frame: CGRect(x: button.right, y: button.height * 0.2, width: lineSize, height: button.height * 0.6))
                lineView.backgroundColor = lineColor
                topView.addSubview(lineView)
            }
        }
        
        // 底部分割线
        if isShowHorizontalLine {
            let bottomLineView = UIView(frame: CGRect(x: 0, y: topView.height - lineSize, width: topView.width, height: lineSize))
            bottomLineView.backgroundColor = lineColor
            topView.addSubview(bottomLineView)
        }
        
        // 底部滑条
        let sliderViewW = sliderWidth == 0 ?  topView.width / CGFloat(subViewCount) : sliderWidth
        let sliderViewX = (btnW - sliderViewW) / 2.0
        sliderView.frame = CGRect(x: sliderViewX, y: topView.height - sliderHeight, width: sliderViewW, height: sliderHeight)
        sliderView.backgroundColor = sliderColor
        topView.addSubview(sliderView)
    }
    
    // 填充子视图
    private func addContentView() {
        
        scrollView.frame = CGRect(x: 0, y: topView.bottom, width: self.width, height: self.height - topView.height)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.GrayColor
        scrollView.bounces = isBounces
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = isAllowHandleScroll
        scrollView.contentSize = CGSize(width: self.width * CGFloat(subViewCount), height: 0)
        self.addSubview(scrollView)
        
        for i in 0 ..< subViewCount {
            let view = contentViews[i]
            let viewX = CGFloat(i) * scrollView.width
            view.frame = CGRect(x: viewX, y: 0, width: scrollView.width, height: scrollView.height)
            scrollView.addSubview(view)
        }
        scrollView.contentOffset = CGPoint(x: CGFloat(selectedIndex) * scrollView.width, y: 0)
    }
    
    // MARK:- 事件
    private func changeView() {
        
        if let btn = topView.viewWithTag(selectedIndex + BaseTag) {
            titleBtnClicked(btn: btn as! UIButton)
        }
    }
    
    // 标题按钮点击
    @objc private func titleBtnClicked(btn: UIButton) {
        
        if btn == selectedBtn {
            return
        }
        
        // 切换选中按钮
        changeSelectedBtn(btn: btn)
        
        // 视图滚动
        UIView.animate(withDuration: 0.25) {
            let num = btn.tag - self.BaseTag
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.width * CGFloat(num), y: 0)
        }
    }
    
    // 滚动监听
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 滑条滚动
        let itemWidth = scrollView.width / CGFloat(subViewCount)
        let xoffset = (itemWidth / scrollView.width) * scrollView.contentOffset.x
        sliderView.transform = CGAffineTransform(translationX: xoffset, y: 0)
    }
    
    // 滚动结束
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        let btn = topView.viewWithTag(index + BaseTag) as! UIButton
        // 切换选中按钮
        changeSelectedBtn(btn: btn)
    }
    
    // 切换选中按钮
    private func changeSelectedBtn(btn: UIButton) {
        
        selectedBtn.isEnabled = true
        btn.isEnabled = false
        selectedBtn = btn
        
        // 按钮缩放动画
        if isShowBtnAnimation {
            scaleAnimationTitleBtn(btn: btn)
        }
    }
    // 按钮缩放动画
    private func scaleAnimationTitleBtn(btn: UIButton) {
        
        UIView.animate(withDuration: 0.25, animations: {
            btn.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }) { (finished) in
            UIView.animate(withDuration: 0.25, animations: {
                btn.transform = CGAffineTransform(scaleX: 1 / 0.9, y: 1 / 0.9)
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.25, animations: {
                    btn.transform = CGAffineTransform.identity
                })
            })
        }
    }
}
    /// 解决滚动视图跟页面的其他滑动手势(PanGuesture)冲突问题
    class RecognizerScrollView: UIScrollView {
        
        override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            
            if gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) {
                let pan = gestureRecognizer as? UIPanGestureRecognizer
                if ((pan?.translation(in: self).x) ?? 0 > CGFloat(0)) && (self.contentOffset.x == CGFloat(0)) {
                    return false
                }
            }
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
    }

