//
//  ASTListener.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/1/30.
//

import Foundation
import Antlr4
import Parser

class ASTListener: MxsBaseListener {
    
    override func enterFunctionDeclaration(_ ctx: MxsParser.FunctionDeclarationContext) {
        print(ctx.Identifier()!.getText())
    }
    
}
