//
//  UIVIewController+Addition.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
}
