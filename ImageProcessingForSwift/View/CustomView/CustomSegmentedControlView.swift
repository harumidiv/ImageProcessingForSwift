//
//  CustomSegmentedControlView.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/21.
//

import UIKit

enum SelectedType: Int {
    case metal
    case uikit
}

protocol CustomSegmentedControlViewDelegate {
    
    /// 選択されているTabが切り替えられた時のイベント
    func changeSelectedRow(number: Int)
}

class CustomSegmentedControlView: UIView {
    var selectedSegmentIndex: Int = 0
    
    private var highlightView: UIView?
    private var centerXPos: CGFloat!
    private let tabSideMargin: CGFloat = 48
    private var tabTitleWidthList: [CGFloat] = []
    private var delegate: CustomSegmentedControlViewDelegate?
    private var buttonsStackView: UIStackView?
    
    // MARK: - Public Method
    
    /// CustomSegmentedControlを初期化するためのメソッド
    /// - Parameters:
    ///   - tabTitleList: tabに表示させる必要のあるTextのList
    ///   - parentCenterX: このViewを表示させている親のViewの中心のX座標
    ///   - delegate: 選択されているIndexの変更を通知するためのdelegate
    ///   - sideMargin: viewを配置した時のマージン
    func setup(tabTitleList: [String], parentCenterX: CGFloat, delegate: CustomSegmentedControlViewDelegate, sideMargin: CGFloat = 40) {
        func createTabButton(size: CGSize, text: String, tag: Int) -> UIView {
            let button = UIButton()
            button.tag = tag
            button.setTitle(text, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.addTarget(self, action:  #selector(tabTapAction), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: size.width).isActive  = true
            button.heightAnchor.constraint(equalToConstant: size.height).isActive  = true
            return button
        }
        
        guard !tabTitleList.isEmpty else {
            return
        }
        
        backgroundColor = .gray
        layer.cornerRadius = 16
        
        self.centerXPos = parentCenterX - sideMargin
        self.delegate = delegate
        
        if let highlightView = self.highlightView {
            highlightView.removeFromSuperview()
        }
        highlightView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        highlightView!.layer.cornerRadius = 16
        highlightView!.backgroundColor = .white
        self.addSubview(highlightView!)
        
        if let buttonsStackView = self.buttonsStackView {
            buttonsStackView.removeFromSuperview()
        }
        buttonsStackView = UIStackView()
        buttonsStackView!.spacing = tabSideMargin
        buttonsStackView!.axis = .horizontal
        buttonsStackView!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonsStackView!)
        
        buttonsStackView!.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        buttonsStackView!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        buttonsStackView!.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        // 初期化
        tabTitleWidthList.removeAll()
        for (index,tabTitle) in tabTitleList.enumerated() {
            let sideMargin: CGFloat = 16
            let width = calculateTextWidth(text: tabTitle) + sideMargin * 2
            tabTitleWidthList.append(width)
            let view = createTabButton(size: CGSize(width: width, height: 40),
                                       text: tabTitle,
                                       tag: index)
            buttonsStackView!.addArrangedSubview(view)
            
        }
        
        highlightView!.frame = CGRect(x: calculateHighlightViewXPosition(selectNum: 0),
                                      y: 8,
                                      width: tabTitleWidthList[0],
                                      height: 40)
    }
    
    // MARK: - Private Method
    
    @objc private func tabTapAction(_ sender: UILabel) {
        let selectIndex = sender.tag
        
        selectedSegmentIndex = selectIndex
        delegate?.changeSelectedRow(number: selectIndex)
        UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
            guard let highlightView = self.highlightView else { return }
            
            highlightView.frame = CGRect(x: self.calculateHighlightViewXPosition(selectNum: selectIndex),
                                         y: 8,
                                         width: self.tabTitleWidthList[sender.tag],
                                         height: 40)
        }, completion: nil)
    }
    
    private func calculateHighlightViewXPosition(selectNum: Int) -> CGFloat {
        let allMargin = CGFloat(tabTitleWidthList.count - 1) * tabSideMargin
        let stackViewWidth = tabTitleWidthList.reduce(0, +) + allMargin
        
        let highlightViewFirstXPos = centerXPos - stackViewWidth / 2
        
        if selectNum == 0 {
            
            return highlightViewFirstXPos
        }
        
        var addXPosition: CGFloat = 0
        for i in 0..<selectNum {
            addXPosition += tabTitleWidthList[i] + tabSideMargin
        }
        
        return highlightViewFirstXPos + addXPosition
    }
    
    private func calculateTextWidth(text: String) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: 24))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        
        label.sizeToFit()
        return label.frame.width
    }
    
}
