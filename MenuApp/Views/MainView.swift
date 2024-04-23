//
//  MainView.swift
//  MenuApp
//
//  Created by Yan Shvyndikov on 22.04.2024.
//

import UIKit

final class MainView: UIView {
    
    private var isMenuButtonTapped = false // маячок для отслеживания нажатий кнопки меню
    private var beacon = true // маячок, чтобы повторно не появлялись кнопки

    private var images = ["settings", "home", "search", "time", "content"]  // картинки для всплывающихся кнопок
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setTitle("Menu", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: 0x008B8B)
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var circleButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x008B8B)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "background")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        setupUI()
    }
    
    @objc private func menuButtonTapped() {
        isMenuButtonTapped.toggle()
        
        // анимация появления кнопок
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            if self.isMenuButtonTapped {
                self.handleMenuButtonTap()
            } else {
                self.hideMenuButtons()
            }
            self.layoutIfNeeded()
        }
        animator.startAnimation()
    }

    // удаление по свайпу
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard let swipedButton = gesture.view as? UIButton else { return }
        
        UIView.animate(withDuration: 0.3) {
            swipedButton.alpha = 0.0
        } completion: { _ in
            swipedButton.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView {
    private func setupUI() {
        addSubviews(backgroundImage, bottomView, circleButtonsStackView, menuButton)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 60),
            
            menuButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            menuButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            menuButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8),
            menuButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            
            circleButtonsStackView.centerXAnchor.constraint(equalTo: menuButton.centerXAnchor),
            circleButtonsStackView.bottomAnchor.constraint(equalTo: menuButton.topAnchor, constant: -20),
        ])
    }
    
    // создание кнопок
    private func createOptionButton(buttonSize: CGSize, image: UIImage) -> UIButton {
        let button = UIButton(frame: .zero)
        button.backgroundColor = UIColor(hex: 0x008B8B)
        button.layer.cornerRadius = buttonSize.height / 2
        button.widthAnchor.constraint(equalToConstant: buttonSize.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonSize.height).isActive = true
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false

        button.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGesture.direction = .left
        button.addGestureRecognizer(swipeGesture)
        
        return button
    }
    
    // чтобы повторно не спавнились кнопки
    private func handleMenuButtonTap() {
        if beacon {
            addOptionButtonsToStackView()
        }
        showMenuButtons()
    }

    // добавление и настройка кнопок
    private func addOptionButtonsToStackView() {
        (1...5).forEach { index in
            let buttonSize = CGSize(width: 70, height: 70)
            let image = UIImage(named: images[index-1]) ?? UIImage()
            let optionButton = createOptionButton(buttonSize: buttonSize, image: image)
            circleButtonsStackView.addArrangedSubview(optionButton)
        }
        beacon = false
    }

    // показать кнопку для анимации
    private func showMenuButtons() {
        circleButtonsStackView.arrangedSubviews.forEach {
            $0.isHidden = false
            $0.alpha = 1.0
        }
    }

    // спрятать кнопку для анимации 
    private func hideMenuButtons() {
        circleButtonsStackView.arrangedSubviews.forEach {
            $0.isHidden = true
            $0.alpha = 0.0
        }
    }
}
