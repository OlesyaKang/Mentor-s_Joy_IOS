//
//  File.swift
//  Mentor's Joy
//
//  Created by Ольга on 02.05.2023.
//

import Foundation
import UIKit

final class TemplateCell: UICollectionViewCell {
    static var reuseIdentifier = "TemplateCell"
    public let button = UIButton()
    public var label = UILabel()
    public var id = Int()
    
    var template: Template? {
        didSet {
            label.text = template?.name
            id = template?.id ?? 0
            setupView()
        }
    }
    
    private func setupView() {
        let templateIcon = UIImage(contentsOfFile: "Group_28")

        contentView.setWidth(to: 154)
        contentView.setHeight(to: 210)
        
        button.backgroundColor = .white
        button.layer.borderColor = .init(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        button.layer.borderWidth = 3
        contentView.addSubview(button)
        button.layer.cornerRadius = 10
        button.pinTop(to: contentView.topAnchor)
        button.setWidth(to: 154)
        button.setHeight(to: 190)
        
        button.setImage(templateIcon, for: .normal)        
        
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.setWidth(to: 160)
        label.textColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        contentView.addSubview(label)
        label.pinBottom(to: contentView.bottomAnchor, -3)
        label.pinCenterX(to: contentView)
        label.textAlignment = .center
        
    }
}
