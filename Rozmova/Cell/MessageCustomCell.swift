//
//  MessageCustomCell.swift
//  Rozmova
//
//  Created by SHIN MIKHAIL on 11.12.2023.
//

import Foundation
import UIKit

final class MessageCustomCell: UITableViewCell {
    var alignment: MessageAlignment = .left {
        didSet {
            messageLabel.textAlignment = (alignment == .left) ? .left : .right
        }
    }
    
    public let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue // Цвет вашего бабла
        view.layer.cornerRadius = 8
        return view
    }()
    public let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
        bubbleView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalTo(bubbleView).inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
