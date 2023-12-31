//
//  ChatViewController.swift
//  Rozmova
//
//  Created by SHIN MIKHAIL on 10.12.2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import FirebaseAuth


enum MessageAlignment {
    case left
    case right
}
struct Message {
    let senderId: String
    let text: String
}
class ChatViewController: UIViewController, InputBarAccessoryViewDelegate, UITableViewDelegate, UITableViewDataSource {
//    var messages: [String] = []  // массив для хранения сообщений
    var messages: [Message] = []

    var messageInputBar = InputBarAccessoryView()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageInputBar()
        configureTableView()
        setupConstraints()
        registerForKeyboardNotifications()
//        configureFirebase()
    }
    
    deinit {
        unregisterForKeyboardNotifications()
    }
    private func configureFirebase() {
        FirebaseApp.configure()
    }
    private func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.sendButton.title = "Send"
        messageInputBar.inputTextView.placeholder = "Enter your message"
        messageInputBar.inputTextView.textColor = .white
        messageInputBar.sendButton.setTitleColor(view.tintColor, for: .normal)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MessageCustomCell.self, forCellReuseIdentifier: "MessageCustomCell")
    }
    
    private func setupConstraints() {
        view.addSubview(messageInputBar)
        messageInputBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(messageInputBar.snp.top)
        }
    }
    
//    public func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        // Handle sending logic here
//        print("Send button pressed with text: \(text)")
//
//        // Добавьте свой код для отправки сообщения на сервер или отображения на экране
//        // Например, добавим текст в какой-то массив сообщений
//
//        let currentDate = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let formattedDate = dateFormatter.string(from: currentDate)
//        let newMessage = "You: \(text)"
//
//        messages.append(newMessage)
//        print("Messages array after adding a new message: \(messages) + \(formattedDate) ")
//
//        // Обновляем таблицу для отображения нового сообщения
//        tableView.reloadData()
//
//        // Очистим текстовое поле после отправки
//        inputBar.inputTextView.text = ""
//    }
//    public func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        // Добавьте логирование перед проверкой аутентификации
//        print("Before authentication check")
//
//        guard let uid = Auth.auth().currentUser?.uid else {
//            print("User is not authenticated")
//            // Дополнительные действия, если пользователь не аутентифицирован
//            return
//        }
//
//        print("User is authenticated with UID: \(uid)")
//
//        let databaseReference = Database.database().reference().child("messages").childByAutoId()
//        let messageData: [String: Any] = ["senderId": uid, "text": text]
//
//        databaseReference.setValue(messageData) { (error, reference) in
//            if let error = error {
//                print("Error sending message: \(error.localizedDescription)")
//            } else {
//                print("Message sent successfully!")
//            }
//        }
//
//        inputBar.inputTextView.text = ""
//    }
//
    public func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print("Failed to sign in anonymously: \(error.localizedDescription)")
                // Дополнительные действия, если вход не выполнен
            } else {
                print("User signed in anonymously!")

                // Теперь пользователь аутентифицирован и вы можете отправить сообщение
                guard let uid = Auth.auth().currentUser?.uid else {
                    print("User is not authenticated")
                    // Дополнительные действия, если пользователь не аутентифицирован
                    return
                }

                print("User is authenticated with UID: \(uid)")

                // Отправка сообщения в базу данных
                let databaseReference = Database.database().reference().child("messages").childByAutoId()
                let messageData: [String: Any] = ["senderId": uid, "text": text]

                databaseReference.setValue(messageData) { (error, reference) in
                    if let error = error {
                        print("Error sending message: \(error.localizedDescription)")
                    } else {
                        print("Message sent successfully!")
                    }
                }

                inputBar.inputTextView.text = ""
            }
        }
    }


}
// таблица
//extension ChatViewController {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCustomCell", for: indexPath) as! MessageCustomCell
//        cell.messageLabel.text = messages[indexPath.row]
//        // Установите alignment в зависимости от отправителя
//        cell.alignment = messages[indexPath.row].starts(with: "You:") ? .right : .left
//        // Установите цвет облачка в зависимости от отправителя
//        cell.bubbleView.backgroundColor = messages[indexPath.row].starts(with: "You:") ? .systemBlue : .systemGray
//
//        return cell
//    }
//}
extension ChatViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCustomCell", for: indexPath) as! MessageCustomCell
//        if let message = messages[indexPath.row] as? [String: Any], let text = message["text"] as? String {
//            cell.messageLabel.text = text
//
//            // Определите alignment и цвет облачка на основе senderId
//            if let senderId = message["senderId"] as? String {
//                cell.alignment = (senderId == Auth.auth().currentUser?.uid) ? .right : .left
//                cell.bubbleView.backgroundColor = (senderId == Auth.auth().currentUser?.uid) ? .systemBlue : .systemGray
//            }
//        }
//
//        return cell
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCustomCell", for: indexPath) as! MessageCustomCell
        
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.text
        cell.alignment = (message.senderId == Auth.auth().currentUser?.uid) ? .right : .left
        cell.bubbleView.backgroundColor = (message.senderId == Auth.auth().currentUser?.uid) ? .systemBlue : .systemGray

        return cell
    }

}


// следим за клавиатурой
extension ChatViewController {
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            updateInputBarBottomConstraint(with: keyboardSize.height)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        updateInputBarBottomConstraint(with: 0)
    }
    
    private func updateInputBarBottomConstraint(with constant: CGFloat) {
        messageInputBar.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-constant)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
