//
//  CXSegmentControl.swift
//  SegmentControl
//
//  Created by 哥春喜 on 2022/1/29.
//

import UIKit

class CXSegmentControl: UIView {
    lazy var collectView: UICollectionView = {
        let v = UICollectionView.init(frame: .zero, collectionViewLayout: collectionViewlayout)
        v.register(CXSegmentItemCell.self, forCellWithReuseIdentifier: CXSegmentItemCell.identify)
        v.backgroundColor = .clear
        v.isPagingEnabled = false
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.bounces = true
        v.delegate = self
        v.dataSource = self
        return v
    }()
    
    var visibleType: CXSegmentVisibleType = .dynamic
    
    var items: [CXSegmentItem] = []
    
    var indicatorConfig = CXSegmentIndicatorConfig.default
    
    var valueDidChange: (Int) -> Void = {_ in }
    
    var defaultSelectedIndex = 0
    
    var defaultItemSpacing = CGFloat(20)
    
    private let indicatorView = UIView()
    
    public private(set) var selectedIndex = 0 {
        didSet {
            valueDidChange(selectedIndex)
        }
    }
    
    lazy var collectionViewlayout: UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout.init()
        l.scrollDirection = .horizontal
        return l
    }()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private var _isFristLayout = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard _isFristLayout else {
            return
        }
        _isFristLayout = false
        collectionViewlayout.minimumLineSpacing = defaultItemSpacing
        collectionViewlayout.minimumInteritemSpacing = defaultItemSpacing
        selectIndex(defaultSelectedIndex, animated: false)
    }
    
    private func setup() {
        clipsToBounds = true
        addSubview(collectView)
        addSubview(indicatorView)
        collectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectView.topAnchor.constraint(equalTo: topAnchor),
            collectView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        indicatorView.backgroundColor = indicatorConfig.color
        indicatorView.layer.cornerRadius = indicatorConfig.cornerRadius
    }
    
    private func updateIndicator(animted: Bool) {
        var indicatorFrame = CGRect.zero
        indicatorFrame.size.height = indicatorConfig.height
        switch indicatorConfig.width {
        case .fix(let width):
            indicatorFrame.size.width = width
            if let att = collectView.layoutAttributesForItem(at: selectedIndexPath) {
                let r = collectView.convert(att.frame, to: self)
                indicatorFrame.origin.x = r.midX - width / 2
            }
        case .ratio(let ratio):
            if let att = collectView.layoutAttributesForItem(at: selectedIndexPath)  {
                let r = collectView.convert(att.frame, to: self)
                let width = r.width * ratio
                indicatorFrame.size.width = r.width * ratio
                indicatorFrame.origin.x = r.midX - width / 2
            }
        }
        switch indicatorConfig.position {
        case .top:
            indicatorFrame.origin.y = indicatorConfig.padding
        case .bottom:
            indicatorFrame.origin.y = frame.height - indicatorConfig.padding - indicatorConfig.height
        }
        UIView.animate(withDuration: animted ? 0.2 : 0, delay: 0) {
            self.indicatorView.frame = indicatorFrame
        }
    }
    
    func selectIndex(_ index: Int, animated: Bool) {
        selectedIndex = index
        collectView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: animated)
        collectView.collectionViewLayout.invalidateLayout()
        collectView.reloadData()
        updateIndicator(animted: animated)
    }
 
    private var selectedIndexPath: IndexPath {
        IndexPath.init(item: selectedIndex, section: 0)
    }
}

extension CXSegmentControl: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CXSegmentItemCell.identify, for: indexPath) as? CXSegmentItemCell else {
            fatalError()
        }
        let item = items[indexPath.item]
        let textContent = item.content.text
        let imageContent = item.content.image
        cell.label.text = textContent?.title
        if selectedIndex == indexPath.item {
            cell.label.font = textContent?.selectedFont
            cell.label.textColor = textContent?.selectedColor
            cell.label.backgroundColor = textContent?.selectedBackgroundColor
            cell.imageView.image = imageContent?.selectedImage
        } else {
            cell.label.font = textContent?.font
            cell.label.textColor = textContent?.color
            cell.label.backgroundColor = textContent?.backgroundColor
            cell.imageView.image = imageContent?.normalImage
        }
        cell.stack.arrangedSubviews.forEach({$0.removeFromSuperview()})
        switch item.content {
        case .text:
            cell.stack.addArrangedSubview(cell.label)
        case .image:
            cell.stack.addArrangedSubview(cell.imageView)
        case .textImage(_, _, let imagePosition):
            cell.stack.spacing = imagePosition.spacing
            switch imagePosition {
            case .left:
                cell.stack.addArrangedSubview(cell.imageView)
                cell.stack.addArrangedSubview(cell.label)
            case .right:
                cell.stack.addArrangedSubview(cell.label)
                cell.stack.addArrangedSubview(cell.imageView)
            case .top:
                cell.stack.addArrangedSubview(cell.imageView)
                cell.stack.addArrangedSubview(cell.label)
            case .bottom:
                cell.stack.addArrangedSubview(cell.label)
                cell.stack.addArrangedSubview(cell.imageView)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
        collectView.collectionViewLayout.invalidateLayout()
        collectView.reloadData()
        updateIndicator(animted: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch visibleType {
        case .dynamic:
            let item = items[indexPath.item]
            return CGSize.init(width: item.contentWidth, height: collectionView.frame.height)
        case .fixed(let maxVisibleItems):
            let maxCount = maxVisibleItems > items.count ? items.count : maxVisibleItems
            let width = (collectionView.frame.width - self.collectionViewlayout.minimumLineSpacing * CGFloat(maxCount - 1)) / CGFloat(maxCount)
            return .init(width: width, height: collectionView.frame.height)
        }
        
    }
}

extension CXSegmentControl: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateIndicator(animted: false)
    }
}
