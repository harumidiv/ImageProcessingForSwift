//
//  ComparisonConversionView.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

class ComparisonConversionView: UIView {
    
    @IBOutlet private weak var beforeImage: UIImageView!
    @IBOutlet private weak var afterImage: UIImageView!
    var tapHandler:(()->Void)?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        let view = Bundle.main.loadNibNamed("ComparisonConversionView",
                                            owner: self,
                                            options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    // MARK: - Action
    @IBAction func tapAction(_ sender: Any) {
        tapHandler?()
    }
}
