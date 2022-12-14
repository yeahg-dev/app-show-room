//
//  TextSymbolView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/03.
//

import UIKit

private enum Design {
    
    static let font: UIFont = .boldSystemFont(ofSize: 25)
    static let color: UIColor = .gray
    static let width: CGFloat = 90
    static let height: CGFloat = 33
}

final class TextSymbolView: UIView {
    
    private let text: String
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.text
        label.font = Design.font
        label.textColor = Design.color
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.sizeToFit()
        return label
    }()
    
    var image: UIImage {
        return self.toImage()
    }
    
    init(_ text: String) {
        self.text = text
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: Design.width, height: Design.height)))
        configureSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubview(){
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    }
    
}
