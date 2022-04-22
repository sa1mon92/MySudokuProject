//
//  SudokuGameCollectionViewCell.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 07.04.2022.
//

import UIKit

class SudokuGameCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "SudokuGameCollectionViewCell"
    
    
    private lazy var pencilLabels = [UILabel]()
    private lazy var cellLabel: UILabel = {
       let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 45)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        pencilLabels.forEach { label in
            label.removeFromSuperview()
        }
        cellLabel.removeFromSuperview()
        layer.sublayers?.removeAll()
        backgroundColor = nil
    }
    
    //Установка цифры карандашом
    func setPencil(forNumber number: Int) {
        
        guard number >= 1 && number <= 9 else { return }
        
        let label = UILabel()
        label.text = String(number)
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 13)
        label.textColor = .gray
        if let frame = getFrame(forIndex: number - 1) {
            label.frame = frame
        }
        pencilLabels.append(label)
        self.addSubview(label)
    }
    
    // получение фрейма для карандашного значения
    private func getFrame(forIndex index: Int) -> CGRect? {
        
        var frame: CGRect?
        let cellWidth = self.frame.width
        let cellHeight = self.frame.height
        switch index {
        case 0:
            frame = CGRect(x: 0, y: 0, width: cellWidth / 3, height: cellHeight / 3)
        case 1:
            frame = CGRect(x: cellWidth / 3, y: 0, width: cellWidth / 3, height: cellHeight / 3)
        case 2:
            frame = CGRect(x: (cellWidth / 3) * 2, y: 0, width: cellWidth / 3, height: cellHeight / 3)
        case 3:
            frame = CGRect(x: 0, y: cellWidth / 3, width: cellWidth / 3, height: cellHeight / 3)
        case 4:
            frame =  CGRect(x: cellWidth / 3, y: cellWidth / 3, width: cellWidth / 3, height: cellHeight / 3)
        case 5:
            frame = CGRect(x: (cellWidth / 3) * 2, y: cellWidth / 3, width: cellWidth / 3, height: cellHeight / 3)
        case 6:
            frame = CGRect(x: 0, y: (cellWidth / 3) * 2, width: cellWidth / 3, height: cellHeight / 3)
        case 7:
            frame = CGRect(x: cellWidth / 3, y: (cellWidth / 3) * 2, width: cellWidth / 3, height: cellHeight / 3)
        case 8:
            frame = CGRect(x: (cellWidth / 3) * 2, y: (cellWidth / 3) * 2, width: cellWidth / 3, height: cellHeight / 3)
        default: break
        }
        return frame
    }
    
    //Установка цифры
    func setNumber(_ number: Int, color: UIColor){
        
        cellLabel.text = String(number)
        self.addSubview(cellLabel)
        cellLabel.textColor = color
    }
    
    //Установка бэкграунда
    func setupBackgroundColorForCell(color: UIColor) {
        self.backgroundColor = color
    }
}
