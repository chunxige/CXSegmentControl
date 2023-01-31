//
//  ViewController.swift
//  SegmentControl
//
//  Created by 哥春喜 on 2022/1/29.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    lazy var segControl: CXSegmentControl = {
        let s = CXSegmentControl.init(frame: .zero)
        s.items = [.init(content: .image(createImageItem())),
                   .init(content: .image(createImageItem())),
                   .init(content: .text(createTextItem("HELLO"))),
                   .init(content: .image(createImageItem())),
                   .init(content: .image(createImageItem())),
                   .init(content: .textImage(createTextItem("AAA"), createImageItem(), .left(spacing: 2)))
                   
        ]
        s.visibleType = .fixed(maxVisibleItems: 4)
        //s.visibleType = .dynamic
        s.defaultItemSpacing = 50
        s.indicatorConfig.padding = 0
        s.indicatorConfig.position = .bottom
        s.indicatorConfig.width = .fix(20)
        s.defaultSelectedIndex = 5
        s.valueDidChange = { idx in
            print(idx)
        }
        return s
    }()
    
    func createTextItem(_ text: String) -> CXSegmentContent.Text {
        .init(title: text, color: .red, font: UIFont.systemFont(ofSize: 13), backgroundColor: .clear, selectedColor: .blue, selectedFont: UIFont.systemFont(ofSize: 18), selectedBackgroundColor: .clear)
    }
    
    func createImageItem() -> CXSegmentContent.Image {
        .init(normalImage: UIImage(named: "im_follow"), selectedImage: .init(named: "im_followed"))
    }
    lazy var clickBtn: UIButton = {
        let b = UIButton.init(type: .custom)
        b.setTitle("click", for: .normal)
        b.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(segControl)
        view.addSubview(clickBtn)
        segControl.backgroundColor = .gray
        segControl.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(100)
            make.right.equalTo(-10)
            make.height.equalTo(60)
        }
        clickBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    var currentIndex = 0
    @objc func clickAction() {
        if currentIndex == segControl.items.count {
            currentIndex = 0
        }
        segControl.selectIndex(currentIndex, animated: true)
        currentIndex += 1
    }
}

