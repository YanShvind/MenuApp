//
//  ViewController.swift
//  MenuApp
//
//  Created by Yan Shvyndikov on 22.04.2024.
//

import UIKit

final class MainViewController: UIViewController {

    private var mainView: MainView {
        return view as! MainView
    }
    
    override func loadView() {
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 
    }
}

