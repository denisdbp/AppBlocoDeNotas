//
//  Alertas.swift
//  BlocoDeAnotacoes
//
//  Created by Admin on 02/10/22.
//

import Foundation
import UIKit

class Alertas {
    
    static let shared:Alertas = Alertas()
    
    private init(){}
    
    public func alertaParaRemover(titulo:String, mensagem:String, controller:UIViewController, handler:@escaping ((UIAlertAction)->Void)){
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .actionSheet)
        let botaoRemover = UIAlertAction(title: "Remover", style: .destructive, handler: handler)
        let botaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alerta.addAction(botaoRemover)
        alerta.addAction(botaoCancelar)
        alerta.popoverPresentationController?.sourceView = controller.view
        alerta.popoverPresentationController?.sourceRect = CGRect(x: controller.view.bounds.width / 2, y: controller.view.bounds.height / 2, width: 0, height: 0)
        alerta.popoverPresentationController?.permittedArrowDirections = .up
        controller.present(alerta, animated: true, completion: nil)
    }
    
    public func alertaGenerico(titulo:String, mensagem:String, controller:UIViewController){
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .actionSheet)
        let botaoOk = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alerta.addAction(botaoOk)
        controller.present(alerta, animated: true, completion: nil)
    }
}
