//
//  LocationInputActivationView.swift
//  UberClone
//
//  Created by Kerim Civelek on 4.11.2023.
//

import UIKit

protocol LocationInputActivationViewDelegate: AnyObject{
    func presentLocationInputView()
}

class LocationInputActivationView: UIView{
    
    //MARK: - Properties
    
    weak var delegate: LocationInputActivationViewDelegate?
    
    private let indicatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Where to?"
        label.font = UIFont(name: "Avenir Medium", size: 16)
        label.textColor = .darkGray
        return label
    }()
    
    //MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 8
        addShadow()
        
        
        addSubview(indicatorView)
        indicatorView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        indicatorView.setDimensions(height: 6, width: 6)
        
        addSubview(placeholderLabel)
        placeholderLabel.centerY(inView: self, leftAnchor: indicatorView.rightAnchor, paddingLeft: 20)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleShowLocationInputView))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleShowLocationInputView(){

        delegate?.presentLocationInputView()
    }
}
