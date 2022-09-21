//
//  ComparisonConversionView.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

final class ComparisonConversionView: UIView {
    @IBOutlet weak var beforeImage: UIImageView!
    @IBOutlet weak var afterImage: UIImageView!
    @IBOutlet private weak var segmentedBaseView: UIView!
    @IBOutlet private weak var convertButton: UIButton!
    
    var segmentedControl: CustomSegmentedControlView!
    
    func setup(before: UIImage? = UIImage(named: "harumi"), after: UIImage? = UIImage(named: "no_image"), target: Any?, action: Selector, segmentedControlDelegate: CustomSegmentedControlViewDelegate) {
        afterImage.image = after
        beforeImage.image = before
        convertButton.addTarget(target,
                                action: action,
                                for: .touchUpInside)
        setupCustomSegmentedControl(delegate: segmentedControlDelegate)
    }
    
    private func setupCustomSegmentedControl(delegate: CustomSegmentedControlViewDelegate) {
        segmentedControl = CustomSegmentedControlView()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedBaseView.addSubview(segmentedControl)
        
        segmentedControl.topAnchor.constraint(equalTo: segmentedBaseView.topAnchor).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: segmentedBaseView.bottomAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: segmentedBaseView.leadingAnchor, constant: 40).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: segmentedBaseView.trailingAnchor, constant: -40).isActive = true
        segmentedControl.setup(tabTitleList: ["Metal", "UIKit"], parentCenterX: UIScreen.main.bounds.size.width/2, delegate: delegate)
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
