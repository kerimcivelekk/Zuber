//
//  LocationInputView.swift
//  UberClone
//
//  Created by Kerim Civelek on 4.11.2023.
//

import UIKit

protocol LocationInputViewDelegate: AnyObject{
    func dissmisLocationInputView()
}

class LocationInputView: UIView{
    
    //MARK: - Properties
    
    weak var delegate: LocationInputViewDelegate?
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp.png").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.backgroundColor = .systemBlue
        return button
    }()
    
    //MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addShadow()
        backgroundColor = .white
        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12, width: 24, height: 24)
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - selectors

    @objc func handleBackTapped(){
        print(123)
        delegate?.dissmisLocationInputView()
    }
}
