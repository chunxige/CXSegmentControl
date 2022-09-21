//
//  CXSegmentItemCell.swift
//  SegmentControl
//
//  Created by 哥春喜 on 2022/9/21.
//

import UIKit

class CXSegmentItemCell: UICollectionViewCell {
    static let identify = "CXSegmentItemCell"
    let label = CXSegmentLabel()
    let imageView = UIImageView()
    let stack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.distribution = .equalSpacing
        s.alignment = .center
        return s
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.isEnabled = false
        imageView.contentMode = .center
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                                     stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                    ])
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(imageView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
