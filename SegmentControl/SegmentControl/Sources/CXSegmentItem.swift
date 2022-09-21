//
//  CXSegmentItem.swift
//  SegmentControl
//
//  Created by 哥春喜 on 2022/1/29.
//

import Foundation
import UIKit

struct CXSegmentItem {
    var content: CXSegmentContent
}

extension CXSegmentItem {
    var contentWidth: CGFloat {
        func textWidth(_ text: CXSegmentContent.Text) -> CGFloat {
            let l = UILabel()
            l.text = text.title
            l.font = text.selectedFont
            l.sizeToFit()
            return l.intrinsicContentSize.width
        }
        func imageWidth(_ image: CXSegmentContent.Image) -> CGFloat {
            guard let selectImage = image.selectedImage else { fatalError() }
            return selectImage.size.width
        }
        
        switch content {
        case .text(let text):
            return textWidth(text)
        case .image(let image):
            return imageWidth(image)
        case .textImage(let text, let image, let position):
            switch position {
            case .left,.right:
                return textWidth(text) + imageWidth(image)
            case .top, .bottom:
                return max(textWidth(text), imageWidth(image))
            }
        }
    }
    
    var hasText: Bool {
        switch content {
        case .text, .textImage:
            return true
        default:
            return false
        }
    }
}

enum CXSegmentContent {
    case text(Text)
    case image(Image)
    case textImage(Text, Image, ImagePosition)
    
    var text: Text? {
        switch self {
        case .text(let text):
            return text
        case .image:
            return nil
        case .textImage(let text, _, _):
            return text
        }
    }
    
    var image: Image? {
        switch self {
        case .text:
            return nil
        case .image(let image):
            return image
        case .textImage(_, let image, _):
            return image
        }
    }
    
    enum ImagePosition {
        case left(spacing: CGFloat)
        case right(spacing: CGFloat)
        case top(spacing: CGFloat)
        case bottom(spacing: CGFloat)
        
        var spacing: CGFloat {
            switch self {
            case .left(let spacing):
                return spacing
            case .right(let spacing):
                return spacing
            case .top(let spacing):
                return spacing
            case .bottom(let spacing):
                return spacing
            }
        }
    }
    
    struct Text {
        let title: String
        let color: UIColor
        let font: UIFont
        let backgroundColor: UIColor
        let selectedColor: UIColor
        let selectedFont: UIFont
        let selectedBackgroundColor: UIColor

    }
    
    struct Image {
        let normalImage: UIImage?
        let selectedImage: UIImage?
    }
}
