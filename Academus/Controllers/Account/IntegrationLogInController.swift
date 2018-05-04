//
//  LogInIntegrationController.swift
//  Academus
//
//  Created by Jaden Moore on 3/2/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class IntegrationLogInController: UIViewController, getStatusDelegate {

    let statusService = StatusService()
    var integrationService: IntegrationService?
    var integration: IntegrationChoice?
    var integrationName: String?
    var coursesController: CoursesController?
    var fields: [UITextField] = []

    var statusAlert: UIView?
    
    let titleLabel = UILabel().setUpLabel(text: "", font: UIFont(name: "AvenirNext-demibold", size: 36)!, fontColor: .navigationsGreen)
    let subtitle = UILabel().setUpLabel(text: "Sign into your", font: UIFont(name: "AvenirNext-medium", size: 24)!, fontColor: .navigationsWhite)
    let button = UIButton(type: .system).setUpButton(title: "SIGN IN", font: UIFont.standard!, fontColor: .navigationsGreen)
    
    @objc func logInPressed() {
        guard let fieldsCounts = integration?.fields.count else {return}
        for i in 0...fieldsCounts - 1 {
            fields[i].resignFirstResponder()
            if (fields[i].text?.isEmpty)! {
                alertMessage(title: "Alert", message: "There is a missing field.")
                return
            }
        }
        
        loadingAlert(title: "Please wait", message: "Attempting to add new integration")
        integrationService?.addIntegration(fields: fields) { (success, error) in
            if success {
                self.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                    self.coursesController?.didAddIntegration()
                })
            } else {
                self.dismiss(animated: true, completion: {
                    self.alertMessage(title: "An error has occurred", message: error ?? "Please try again later.")
                })
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusService.statusDelegate = self
        statusService.getStatus { _ in }
        
        hideKeyboard()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func didGetStatus(components: [ComponentModel]) {
        if components.isEmpty {
            statusAlert?.removeFromSuperview()
            statusAlert = nil
        } else {
            if let index = components.index(where: { $0.name == titleLabel.text }),
                let status = components[index].status, status > 1,
                let name = components[index].name, name == titleLabel.text,
                let statusName = components[index].statusName {
                statusAlert = statusBarHeaderView(message: "\(name): \(statusName)", severity: status)
                view.addSubview(statusAlert!)
                statusAlert!.anchors(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 57)
            } else if let mostSevere = components.max(by: { ($0.status ?? 0) < ($1.status ?? 0) }),
                let status = mostSevere.status, status > 1,
                let name = mostSevere.name,
                let statusName = mostSevere.statusName {
                statusAlert = statusBarHeaderView(message: "\(name): \(statusName)", severity: status)
                view.addSubview(statusAlert!)
                statusAlert!.anchors(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 57)
            } else {
                statusAlert?.removeFromSuperview()
                statusAlert = nil
            }
        }
    }

    private func setUpUI() {
        self.view.backgroundColor = .tableViewDarkGrey
        
        let screen = UIScreen.main.bounds
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: screen.width, height: screen.height)
        scrollView.isScrollEnabled = true
        scrollView.addSubviews(views: [subtitle, titleLabel, button])
        
        view.addSubview(scrollView)
        scrollView.anchors(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        guard let fieldCount = integration?.fields.count else {return}
        for i in 0...fieldCount - 1 {
            let field = UITextField().setupTextField(bgColor: .tableViewDarkGrey, bottomBorder: true, ghostText: integration?.fields[i].label, isLeftImage: false, isSecure: false)
            field.font = UIFont.standard!
            if integration?.fields[i].id == "password" {
                field.isSecureTextEntry = true
            }
            scrollView.addSubview(field)
            field.anchors(top: fields.last?.topAnchor ?? titleLabel.topAnchor, topPad: (fields.last != nil) ? 54 : 72, leftPad: 32, rightPad: -32, centerX: scrollView.centerXAnchor, width: screen.width - 64, height: fieldHeight)
            fields.append(field)
        }
        
        subtitle.anchors(top: scrollView.topAnchor, topPad: 120, centerX: scrollView.centerXAnchor)
        titleLabel.anchors(top: subtitle.bottomAnchor, centerX: scrollView.centerXAnchor, width: 0, height: 0)
        button.anchors(top: fields.last?.bottomAnchor, topPad: 32, centerX: scrollView.centerXAnchor, width: 84)
        button.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
    }
    
    private func statusBarHeaderView(message: String, severity: Int) -> UIView {
        let view = UIView(frame: CGRect(x: 20, y: 0, width: 0, height: 72))
        var bgColor: UIColor
        
        switch severity {
        case 2: bgColor = UIColor().HexToUIColor(hex: "#EF6C00")
        case 3: bgColor = UIColor().HexToUIColor(hex: "#EF6C00")
        case 4: bgColor = .navigationsRed
        default: bgColor = .navigationsRed
        }
        
        let background = UIButton().setUpButton(bgColor: bgColor, title: message, font: UIFont.header!, fontColor: .navigationsWhite, state: .normal)
        background.contentVerticalAlignment = .top
        background.addTarget(self, action: #selector(statusPage), for: .touchUpInside)
        background.roundCorners(corners: .bottom)
        background.setUpShadow(color: .black, offset: CGSize(width: 0, height: 0), radius: 4, opacity: 0.2)
        
        let closeButton = UIButton()
        closeButton.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        closeButton.tintColor = .navigationsWhite
        closeButton.addTarget(self, action: #selector(dismissStatusAlert), for: .touchUpInside)
        let statusSubtext = UILabel().setUpLabel(text: "Tap for more details.", font: UIFont.subtext!, fontColor: .navigationsWhite)
        statusSubtext.textAlignment = .center
        
        background.addSubviews(views: [closeButton, statusSubtext])
        view.addSubview(background)
        
        background.anchors(top: view.topAnchor, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 9, right: view.rightAnchor, rightPad: -9)
        statusSubtext.anchors(bottom: background.bottomAnchor, bottomPad: -5, centerX: background.centerXAnchor)
        closeButton.anchors(right: background.rightAnchor, rightPad: -9, centerY: background.centerYAnchor, width: 28, height: 28)
        
        return view
    }
    
    @objc func statusPage() {
        
    }
    
    @objc func dismissStatusAlert() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.statusAlert?.removeFromSuperview()
        })
    }
}

