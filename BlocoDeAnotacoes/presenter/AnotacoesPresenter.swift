//
//  AnotacoesPresenter.swift
//  BlocoDeAnotacoes
//
//  Created by Admin on 11/09/22.
//

import Foundation
import CoreData
import UIKit

protocol MinhasAnotacoesProtocol {
    func mostraAnotacoes(model:[AnotacoesModel])
    func erroGenerico()
}

protocol AnotacoesProtocol {
    func verificaDadosVazios()
    func limparCamposAnotacoes()
    func erroGenerico()
}

class AnotacoesPresenter {
    
    var model:[AnotacoesModel] = []
    
    public var minhasAnotacoesProtocol:MinhasAnotacoesProtocol?
    public var anotacoesProtocol:AnotacoesProtocol?
    
    public func gerarIdAnotacao()->String{
        let id = String(Int.random(in: 0...1000000))
        return id
    }
    
    func mostrarAnotacoes(){
        self.model.removeAll()
        do {
            let result = try CoreData.shared.coreDataContext().fetch(CoreData.shared.fetchRequest())
            for data in result as! [NSManagedObject] {
                self.model.append(AnotacoesModel(id: data.value(forKey: "id") as? String ?? "", titulo: data.value(forKey: "titulo") as? String ?? "", anotacao: data.value(forKey: "anotacao") as? String ?? "", ultimaAlteracao: data.value(forKey: "ultimaAlteracao") as? String ?? ""))
                self.model = self.model.sorted(by: {$0.ultimaAlteracao > $1.ultimaAlteracao})
            }
        }catch {
            self.minhasAnotacoesProtocol?.erroGenerico()
        }
        self.minhasAnotacoesProtocol?.mostraAnotacoes(model: self.model)
    }
    
    public func salvarAnotacao(id:String, titulo:String, anotacao:String, ultimaAlteracao:String){
        if titulo.isEmpty || anotacao.isEmpty {
            self.anotacoesProtocol?.verificaDadosVazios()
        }else {
            let novoId = self.gerarIdAnotacao()
            let novaAnotacao = NSManagedObject(entity: CoreData.shared.entityName(), insertInto: CoreData.shared.coreDataContext())
            novaAnotacao.setValue(titulo, forKey: "titulo")
            novaAnotacao.setValue(anotacao, forKey: "anotacao")
            novaAnotacao.setValue(ultimaAlteracao, forKey: "ultimaAlteracao")
            novaAnotacao.setValue(novoId, forKey: "id")
            do{
                try CoreData.shared.coreDataContext().save()
                self.anotacoesProtocol?.limparCamposAnotacoes()
            }catch{
                self.anotacoesProtocol?.erroGenerico()
            }
        }
    }
    
    public func verificarSeIdExiste(id:String)->[NSManagedObject]?{
        let request = CoreData.shared.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let result = try CoreData.shared.coreDataContext().fetch(request) as? [NSManagedObject]
            if result?.count != 0{
                return result
            }else {
                return []
            }
        }catch{
            self.anotacoesProtocol?.erroGenerico()
        }
        return []
    }
    
    public func alterarAnotacao(id:String, titulo:String, anotacao:String, ultimaAlteracao:String){
        if let resultado = self.verificarSeIdExiste(id: id){
            if resultado.count != 0{
                resultado[0].setValue(titulo, forKey: "titulo")
                resultado[0].setValue(anotacao, forKey: "anotacao")
                resultado[0].setValue(ultimaAlteracao, forKey: "ultimaAlteracao")
                resultado[0].setValue(id, forKey: "id")
                do{
                    try CoreData.shared.coreDataContext().save()
                    self.anotacoesProtocol?.limparCamposAnotacoes()
                }catch{
                    self.anotacoesProtocol?.erroGenerico()
                }
            }else {
                self.salvarAnotacao(id: id, titulo: titulo, anotacao: anotacao, ultimaAlteracao: ultimaAlteracao)
            }
        }
    }
    
    func apagarAnotacoes(id:String){
        if let resultado = self.verificarSeIdExiste(id: id) {
            if resultado.count != 0 {
                CoreData.shared.coreDataContext().delete(resultado[0])
                do{
                    try CoreData.shared.coreDataContext().save()
                    self.mostrarAnotacoes()
                }catch{
                    self.minhasAnotacoesProtocol?.erroGenerico()
                }
            }else{
                self.minhasAnotacoesProtocol?.erroGenerico()
            }
        }
    }
    
    public func pesquisarAnotacao(pesquisa:String){
        let respostaPesquisa = self.model.filter({return $0.titulo == pesquisa || $0.anotacao == pesquisa})
        if respostaPesquisa.count > 0 {
            self.minhasAnotacoesProtocol?.mostraAnotacoes(model: respostaPesquisa)
        }else {
            self.minhasAnotacoesProtocol?.mostraAnotacoes(model: self.model)
        }
    }
}

