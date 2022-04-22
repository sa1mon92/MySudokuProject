//
//  SudokuGameViewController.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 07.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SudokuGameDisplayLogic: AnyObject {
    func displayData(viewModel: SudokuGame.Model.ViewModel.ViewModelData)
}

class SudokuGameViewController: UIViewController, SudokuGameDisplayLogic {
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        let height = self.view.frame.height
        let width = self.view.frame.width
        let frame = CGRect(x: 0, y: height / 2 - width / 2 - 60, width: width, height: width)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = .black
        return cv
    }()
    
    private lazy var menuButton: UIButton = {
       let button = UIButton()
        let size = self.view.frame.width / 12
        let height = self.view.frame.height
        let width = self.view.frame.width
        button.frame = CGRect(x: 5, y: height / 2 - width / 2 - 65 - width / 10 - size, width: size * 3.5, height: size)
        button.setImage(UIImage(named: "Menu"), for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(pauseButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var numbersStackView: UIStackView = {
        let sv = UIStackView()
        let height = self.view.frame.height
        let width = self.view.frame.width
        sv.frame = CGRect(x: 0, y: height / 2 + width / 2 - 40, width: width, height: width / 9)
        return sv
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let sv = UIStackView()
        let height = self.view.frame.height
        let width = self.view.frame.width
        sv.frame = CGRect(x: 0, y: height / 2 + width / 2 + 20, width: self.view.frame.width, height: width / 8)
        return sv
    }()
    
    private lazy var errorsStackView: UIStackView = {
        let sv = UIStackView()
        let height = self.view.frame.height
        let width = self.view.frame.width
        sv.frame = CGRect(x: 0, y: height / 2 - width / 2 - 60 - width / 10, width: width / 2, height: width / 10)
        return sv
    }()
    
    private lazy var pauseButton: UIButton = {
        let button = UIButton()
        let size = self.view.frame.width / 8
        button.frame = CGRect(x: size / 2, y: 0, width: size, height: size)
        button.setImage(UIImage(named: "Pause"), for: .normal)
        button.addTarget(self, action: #selector(pauseButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var eraserButton: UIButton = {
        let button = UIButton()
        let size = self.view.frame.width / 8
        button.frame = CGRect(x: size / 2 + size * 2, y: 0, width: size, height: size)
        button.setImage(UIImage(named: "Eraser"), for: .normal)
        button.addTarget(self, action: #selector(eraserButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var lampButton: UIButton = {
        let button = UIButton()
        let size = self.view.frame.width / 8
        button.frame = CGRect(x: size / 2 + size * 4, y: 0, width: size, height: size)
        button.addTarget(self, action: #selector(lampButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var pencilButton: UIButton = {
        let button = UIButton()
        let size = self.view.frame.width / 8
        button.frame = CGRect(x: size / 2 + size * 6, y: 0, width: size, height: size)
        button.addTarget(self, action: #selector(pencilButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var numbersButtonCollection: [UIButton] = {
        var buttonsArray = [UIButton]()
        for index in 0...8 {
            let button = UIButton()
            let size = self.view.frame.width / 9
            button.frame = CGRect(x: size * CGFloat(index), y: 0, width: size, height: size)
            button.setTitle(String(index + 1), for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo Medium", size: 35)
            button.addTarget(self, action: #selector(numberButtonClick(_:)), for: .touchUpInside)
            buttonsArray.append(button)
        }
        return buttonsArray
    }()
    
    private lazy var errorsImageCollection: [UIImageView] = {
        var imageViewsArray = [UIImageView]()
        for index in 0...4 {
            let imageView = UIImageView()
            let size = self.view.frame.width / 10
            imageView.frame = CGRect(x: size * CGFloat(index), y: 0, width: size, height: size)
            imageView.image = UIImage(named: "x-gray")
            imageViewsArray.append(imageView)
        }
        return imageViewsArray
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        let height = self.view.frame.height
        let width = self.view.frame.width
        label.frame = CGRect(x: (width / 3) * 2, y: height / 2 - width / 2 - 60 - width / 10, width: width / 3 - 5, height: width / 10)
        label.textAlignment = .right
        label.font = UIFont(name: "Apple SD Gothic Neo Medium", size: 27)
        return label
    }()
    
    var interactor: SudokuGameBusinessLogic?
    var router: (NSObjectProtocol & SudokuGameRoutingLogic)?
    
    private var viewModel: SudokuGameViewModel?
    
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
        let interactor            = SudokuGameInteractor()
        let presenter             = SudokuGamePresenter()
        let router                = SudokuGameRouter()
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
        collectionView.register(SudokuGameCollectionViewCell.self, forCellWithReuseIdentifier: SudokuGameCollectionViewCell.reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.backgroundColor = .white
        setSubviews()
    }
    
    override var prefersStatusBarHidden: Bool {
      return true
    }
    
    private func setSubviews() {
        view.addSubview(collectionView)
        view.addSubview(menuButton)
        view.addSubview(timerLabel)
        view.addSubview(numbersStackView)
        view.addSubview(buttonsStackView)
        view.addSubview(errorsStackView)
        buttonsStackView.addSubview(pauseButton)
        buttonsStackView.addSubview(eraserButton)
        
        for button in numbersButtonCollection {
            numbersStackView.addSubview(button)
        }
        
        for errorImage in errorsImageCollection {
            errorsStackView.addSubview(errorImage)
        }
    }
    
    func displayData(viewModel: SudokuGame.Model.ViewModel.ViewModelData) {

        switch viewModel {
        case .displayGame(viewModel: let viewModel):
            self.viewModel = viewModel
            setErrors(count: viewModel.errorCount)
            setLamps(count: viewModel.lampCount)
            setPencilButton(isEnable: viewModel.pencilIsEnable)
            collectionView.reloadData()
        case .displayGameOver:
            router?.displayGameOver()
        case .displayPause:
            router?.displayPause()
        case .presentTimer(text: let text):
            timerLabel.text = text
        }
    }
    
    private func setPencilButton(isEnable: Bool) {
        
        var imageName = ""
        switch isEnable {
        case true:
            imageName = "PencilOn"
        case false:
            imageName = "PencilOff"
        }
        
        if let image = UIImage(named: imageName) {
            pencilButton.setImage(image, for: .normal)
            buttonsStackView.addSubview(pencilButton)
        }
    }
    
    private func setLamps(count: Int) {
        
        var imageName = ""
        switch count {
        case 3:
            imageName = "Lamp3"
        case 2:
            imageName = "Lamp2"
        case 1:
            imageName = "Lamp1"
        case 0:
            imageName = "Lamp0"
        default: break
        }
        
        if let image = UIImage(named: imageName) {
            lampButton.setImage(image, for: .normal)
            buttonsStackView.addSubview(lampButton)
        }
    }
    
    private func setErrors(count: Int) {
        guard count > 0, count < 6 else { return }
        
        for i in 0...count - 1 {
            errorsImageCollection[i].image = UIImage(named: "x-red")
        }
    }
    
    @objc private func numberButtonClick(_ sender: UIButton) {
        if let index = numbersButtonCollection.firstIndex(of: sender) {
            interactor?.makeRequest(request: SudokuGame.Model.Request.RequestType.numberButtonTouch(index: index))
        }
    }
    
    
    @objc private func pauseButtonClick(_ sender: UIButton) {
        interactor?.makeRequest(request: SudokuGame.Model.Request.RequestType.pauseButtonTouch)
    }
    
    @objc private func eraserButtonClick(_ sender: UIButton) {
        interactor?.makeRequest(request: SudokuGame.Model.Request.RequestType.eraserButtonTouch)
    }
    
    @objc private func lampButtonClick(_ sender: UIButton) {
        interactor?.makeRequest(request: SudokuGame.Model.Request.RequestType.lampButtonTouch)
    }
    
    @objc private func pencilButtonClick(_ sender: UIButton) {
        interactor?.makeRequest(request: SudokuGame.Model.Request.RequestType.pencilButtonTouch)
    }
    
}

// MARK: - UICollectionViewDataSource

extension SudokuGameViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SudokuGameCollectionViewCell.reuseId, for: indexPath) as! SudokuGameCollectionViewCell
        if let cellViewModel = viewModel?.cells.first(where: { $0.index == indexPath }) {
            cell.setupBackgroundColorForCell(color: cellViewModel.bgColor ?? .white)
            switch cellViewModel.type {
            case .Default:
                if let number = cellViewModel.numberValue {
                    cell.setNumber(number, color: .black)
                }
            case .User:
                if let number = cellViewModel.numberValue {
                    cell.setNumber(number, color: .blue)
                }
            case .Error:
                if let number = cellViewModel.numberValue {
                    cell.setNumber(number, color: .red)
                }
            case .Pencil:
                if let pencilValues = cellViewModel.pencilValues {
                    for pencilValue in pencilValues {
                        cell.setPencil(forNumber: pencilValue)
                    }
                }
            case .Unknown:
                break
            }
        }
        
        switch indexPath.item {
        case 2, 5: cell.addBorderRight(size: 2, color: .black)
        default: break
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SudokuGameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.makeRequest(request: SudokuGame.Model.Request.RequestType.selectCell(index: indexPath))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SudokuGameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/9 - 1, height: view.frame.size.width/9 - 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0: return UIEdgeInsets(top: 3, left: 0, bottom: 1, right: 0)
        case 2, 5: return UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
        case 8: return UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
        default: return UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        }
    }
}
