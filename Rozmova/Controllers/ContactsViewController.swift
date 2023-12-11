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
    private var contactsArray: [ContactModel] = []
    
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
        fetchContacts()
        
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
    // получаем контакты
    private func fetchContacts() {
        // Создайте экземпляр CNContactStore
        let contactStore = CNContactStore()
        // Запрос на получение контактов
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
        // Используйте GCD для выполнения кода в фоновом потоке
        DispatchQueue.global(qos: .background).async {
            do {
                try contactStore.enumerateContacts(with: request) { (contact, _) in
                    // Обработка полученного контакта
                    let name = "\(contact.givenName) \(contact.familyName)"
                    let phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? "Нет номера"

                    // Создайте вашу модель данных и добавьте ее в источник данных вашей таблицы
                    let contactModel = ContactModel(name: name, phoneNumber: phoneNumber)
                    self.contactsArray.append(contactModel)
                }
                // После того как все контакты добавлены, перезагрузите таблицу на главном потоке
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching contacts: \(error)")
            }
        }
    }

}
//MARK: extension TableView
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource{
    // количество контактов котоыре показываем
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsArray.count
    }
    // содержимое ячеки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCustomCell", for: indexPath) as! ContactsCustomCell

        let contact = contactsArray[indexPath.row]
        cell.titleLabel.text = contact.name
        cell.subtitleLabel.text = contact.phoneNumber
        cell.backgroundColor = .clear

        return cell
    }
    // Нажатие на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contactsArray[indexPath.row]
        // Создайте экземпляр ChatViewController
        let chatViewController = ChatViewController()
        // Настройте chatViewController с данными выбранного контакта
        chatViewController.title = selectedContact.name
        // Другие настройки чата...
        // Отобразите chatViewController
        navigationController?.pushViewController(chatViewController, animated: true)
        // Уберите подсветку (выделение) ячейки
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // высота
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}
