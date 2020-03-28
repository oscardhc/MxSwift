# MxSwift
A naive Mx* compiler implemented in Swift.

### Structure

#### Frontend

- Antlr4 based parser.
  - Visitor pattern.
- AST Builder.

  - Each node is associated with a scope.

- Semantic check on AST.
  - Use an error handler.

#### IR

- AST based IR Builder.
  - Not strict SSA.
  - Carefully handle user-usee edges.
  - Handwritten linked lists for convenient use.


- IR Numberer and IR Printer to output in LLVM format.
  
  - Use-def chains.
  
- Passes

  - DeadCleaner
    To remove unreachable blocks and instructions after a terminate one.
  
  - Dominance analysis
  
  - DCElimination
  
  - CSElimination
  
  - SCCPropagation
  
  - CFGSimplifier
    Actually the only two situations it can handle are blocks with single pred and single succ or blocks with single pred and is the only succ of it.
  
  - LSElimination
    
  - Inliner    


### Progress

- [x] [1.29] First version of grammar file.
- [x] [1.30] Try to work with Swift.
- [x] [2.1] Abstract Symntax Tree.
- [x] [2.1] Symbol tables.
- [x] [2.2] Declaration check.
- [x] [2.3] Type check.
- [x] [2.5] Semantic check together.
- [x] [2.7] IRBuilder framework.
- [x] [2.10] Control flow generator.
- [x] [2.13] Variables.
- [x] [2.14] Builtin functions (except size).
- [x] [2.15] Size implemented by allocating 4 extra bytes.
- [x] [2.17] Dominator trees.
- [x] [2.18] Mem2Reg.
- [x] [2.19] DCEliminator.
- [x] [2.24] CFGSimplifier.
- [x] [2.27] SCCPropagation.
- [x] [3.11] CSEliminator.
- [x] [3.20] PTAnalysis.
- [x] [3.23] Fix IR short-circuit evaluation.
- [x] [3.25] Fix IR array construction.
- [x] [3.27] Inliner.
- [ ] ...
