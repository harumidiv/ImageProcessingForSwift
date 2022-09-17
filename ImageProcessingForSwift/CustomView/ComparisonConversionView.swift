//
//  ComparisonConversionView.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

class ComparisonConversionView: UIView {

    @IBOutlet weak var beforeImage: UIView!
    @IBOutlet weak var afterImage: UIView!
    
    var tapHandler:(()->Void)?
    
    @IBAction func tapAction(_ sender: Any) {
        tapHandler?()
    }
}
