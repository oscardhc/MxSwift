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

  - 

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
- [x] [2.17] (post) Dominator trees.
- [x] [2.18] Mem2Reg.
- [x] [2.19] MSDCE.
- [ ] ...
