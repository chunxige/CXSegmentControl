//
//  CXSegmentConfig.swift
//  SegmentControl
//
//  Created by 哥春喜 on 2022/9/21.
//

import Foundation
import UIKit

enum CXSegmentVisibleType {
    case dynamic
    case fixed(maxVisibleItems: Int)
}

struct CXSegmentIndicatorConfig {
    var height: CGFloat
    var width: WidthStyle
    var color: UIColor
    var cornerRadius: CGFloat
    var position: Position = .bottom
    var padding: CGFloat
    
    static var `default` = Self.init(height: 3, width: .fix(20), color: .red, cornerRadius: 2, padding: 5)
    
    enum WidthStyle {
        // 固定宽度
        case fix(CGFloat)
        // 比例
        case ratio(CGFloat)
    }
    
    enum Position {
        case top
        case bottom
    }
}
