//
//  ContactsCustomCell.swift
//  Rozmova
//
//  Created by SHIN MIKHAIL on 10.12.2023.
//

import SnapKit
import UIKit
//import SDWebImage

final class ContactsCustomCell: UITableViewCell {
    //MARK: Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemGray
        return label
    }()
    private let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6 // Цвет бордера
        return view
    }()
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    //MARK: Methods
    private func setupConstraints() {
        // titleLabel
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.leading.equalToSuperview().offset(0)
        }
        // subtitle
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(0)
        }
        // bottomBorderView
        addSubview(bottomBorderView)
        bottomBorderView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
} // end
