Pascal-Compiler
===============

This is a Pascal compiler written in C#. The details of the language features are not determined yet. This was intended to be the project of Compiler Theory course at Nanjing University. It is planned that the compiler compiles source into the Intermediate Language(IL) of .Net Framework. 

At first, I decided to use Antlr4 instead of writing parsers by hand. However, there isn't any detailed documentations for Antlr4 in C#, and I found the example Java program in the appendix of dragon book. Then I started building a parser by hand based on the example in dragon book, with the help of Antlrworks2 designing the grammar.

#ANTLR4 Context-Free Grammars
See the SimPas.g4 file.

#Parsing MethodsI built a LL(2) parser, however for most cases LL(1) is enough. For each grammar rule, we have a corresponding method in the Parser class. 

# LICENSE
Which license to be used is not determined yet, maybe MIT License.




