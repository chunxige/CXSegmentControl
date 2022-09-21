//
//  CXSegmentLabel.swift
//  SegmentControl
//
//  Created by 哥春喜 on 2022/9/21.
//

import UIKit

class CXSegmentLabel: UIButton {
    var text: String? {
        get {
            title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    var textColor: UIColor? {
        get {
            titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }
    
    var font: UIFont? {
        get {
            titleLabel?.font
        }
        set {
            titleLabel?.font = newValue
        }
    }
    
    // 系统的Button 内部有间距，需重写
    override var intrinsicContentSize: CGSize {
        guard let t = text, !t.isEmpty else {
            return .zero
        }
        let l = UILabel()
        l.text = t
        l.font = font
        l.sizeToFit()
        return l.intrinsicContentSize
    }

}
