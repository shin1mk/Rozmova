//
//  MainTabBarController.swift
//  Rozmova
//
//  Created by SHIN MIKHAIL on 10.12.2023.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
     }
    //MARK: Create TabBar
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: ContactsViewController(),
                title: "Contacts",
                image: UIImage(systemName: "person.crop.circle.fill")),
            generateVC(
                viewController: MessagesViewController(),
                title: "Messages",
                image: UIImage(systemName: "message.fill")),
        ]
        UITabBar.appearance().tintColor = UIColor.white // Set the selected icon color
    }
    // Generate View Controllers
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
}
