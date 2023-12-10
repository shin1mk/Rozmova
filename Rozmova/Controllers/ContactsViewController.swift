//
//  ContactsViewController.swift
//  Rozmova
//
//  Created by SHIN MIKHAIL on 10.12.2023.
//

import UIKit
import SnapKit
import Contacts

final class ContactsViewController: UIViewController {
    //MARK: Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ContactsCustomCell.self, forCellReuseIdentifier: "ContactsCustomCell")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupTableView()
    }
    //MARK: Methods
    private func setupConstraints() {
        view.backgroundColor = .black
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
    }
    // Delegate/DataSource
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
//MARK: extension TableView
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCustomCell", for: indexPath) as! ContactsCustomCell

        cell.titleLabel.text = "Имя контакта"
        cell.subtitleLabel.text = "Номер телефона"
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}
