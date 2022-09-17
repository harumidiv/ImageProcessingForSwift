//
//  ComparisonConversionView.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

class ComparisonConversionView: UIView {
    
    @IBOutlet weak var beforeImage: UIImageView!
    @IBOutlet weak var afterImage: UIImageView!
    @IBOutlet private weak var convertButton: UIButton!
    
    func setup(before: UIImage? = UIImage(named: "harumi"), target: Any?, action: Selector) {
        beforeImage.image = before
        convertButton.addTarget(target,
                                action: action,
                                for: .touchUpInside)
    }
    
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

}
