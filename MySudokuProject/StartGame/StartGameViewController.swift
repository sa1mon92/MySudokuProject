//
//  StartGameViewController.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 21.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StartGameDisplayLogic: AnyObject {
    func displayData(viewModel: StartGame.Model.ViewModel.ViewModelData)
}

class StartGameViewController: UIViewController, StartGameDisplayLogic {
    
    private lazy var startButton: UIButton = {
       let button = UIButton()
        button.setTitle("START NEW GAME", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: 40)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.center = self.view.center
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(tapStartButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var continueButton: UIButton = {
       let button = UIButton()
        button.setTitle("CONTINUE GAME", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.frame = CGRect(x: self.view.frame.width / 4, y: self.view.frame.height / 2 + 50, width: self.view.frame.width / 2, height: 40)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(tapContinueButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var numbersButtonCollection: [UIButton] = {
        var buttonsArray = [UIButton]()
        for index in 0...2 {
            let button = UIButton()
            button.frame = CGRect(x: 0, y: CGFloat(0 + 70 * index), width: self.view.frame.width / 2, height: 40)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = .clear
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            var titleText: String = ""
            switch index {
            case 0:
                titleText = "EASY"
            case 1:
                titleText = "NORMAL"
            case 2:
                titleText = "HARD"
            default: break
            }
            button.setTitle(titleText, for: .normal)
            button.addTarget(self, action: #selector(difficultButtonClick(_:)), for: .touchUpInside)
            buttonsArray.append(button)
        }
        return buttonsArray
    }()
    
    private lazy var stackView: UIStackView = {
       let sv = UIStackView()
        sv.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: 180)
        sv.center = self.view.center
        return sv
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: self.view.frame.width / 4, y: self.view.frame.height / 2 - 80, width: self.view.frame.width / 2, height: 40)
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    var interactor: StartGameBusinessLogic?
    var router: (NSObjectProtocol & StartGameRoutingLogic)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = StartGameInteractor()
        let presenter             = StartGamePresenter()
        let router                = StartGameRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
   
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(startButton)
        interactor?.makeRequest(request: StartGame.Model.Request.RequestType.checkSavedGame)
    }
    
    func displayData(viewModel: StartGame.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .displayDifficults:
            displayDifficults()
        case .displaySavedGame:
            router?.displaySavedGame()
        case .displayNewGame(difficult: let difficult):
            router?.displayNewGame(difficult: difficult)
        case .displayGameOver:
            displayGameOver()
        case .displayPause:
            displayPause()
        case .displayContinueButton(isEnable: let isEnable):
            displayContinueButton(isEnable: isEnable)
        }
    }
    
    @objc private func tapStartButton() {
        interactor?.makeRequest(request: StartGame.Model.Request.RequestType.startButtonTouch)
    }
    
    @objc private func difficultButtonClick(_ sender: UIButton) {
        if let index = numbersButtonCollection.firstIndex(of: sender) {
            interactor?.makeRequest(request: StartGame.Model.Request.RequestType.difficultButtonTouch(index: index))
        }
    }
    
    @objc private func tapContinueButton() {
        interactor?.makeRequest(request: StartGame.Model.Request.RequestType.continueButtonTouch)
    }
    
    private func displayDifficults() {
        label.removeFromSuperview()
        startButton.removeFromSuperview()
        continueButton.removeFromSuperview()
        view.addSubview(stackView)
        numbersButtonCollection.forEach { button in
            stackView.addSubview(button)
        }
    }
    
    private func displayGameOver() {
        continueButton.removeFromSuperview()
        stackView.removeFromSuperview()
        label.textColor = .red
        label.text = "GAME OVER!"
        view.addSubview(label)
    }
    
    private func displayPause() {
        stackView.removeFromSuperview()
        label.textColor = .blue
        label.text = "PAUSE"
        view.addSubview(label)
    }
    
    private func displayContinueButton(isEnable: Bool) {
        if isEnable {
            view.addSubview(continueButton)
        } else {
            continueButton.removeFromSuperview()
        }
    }
    
}
