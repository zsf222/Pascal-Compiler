
grammar SimPas;

tokens
{
BREAK,
CONTINUE,
CONST,
TYPE,
VAR,
FORWARD,
PROCEDURE,
FUNCTION,
BEGIN,
END,
FOR,
TO,
DOWNTO,
DO,
WHILE,
IF,
THEN,
ELSE,
REPEAT,
UNTIL,
DIV,
MOD,
AND,
NOT,
OR,
ARRAY,
OF,
RECORD
}

@lexer::header { // place this header action only in lexer, not the parser 
using System.Collections.Generic;

}

@lexer::members { // place this class member only in lexer 
Dictionary<string,int> keywords = new Dictionary<string,int>() {{"BREAK",SimPasParser.BREAK},
{"CONTINUE",SimPasParser.CONTINUE},
{"CONST",SimPasParser.CONST},
{"TYPE",SimPasParser.TYPE},
{"VAR",SimPasParser.VAR},
{"FORWARD",SimPasParser.FORWARD},
{"PROCEDURE",SimPasParser.PROCEDURE},
{"FUNCTION",SimPasParser.FUNCTION},
{"BEGIN",SimPasParser.BEGIN},
{"END",SimPasParser.END},
{"FOR",SimPasParser.FOR},
{"TO",SimPasParser.TO},
{"DOWNTO",SimPasParser.DOWNTO},
{"DO",SimPasParser.DO},
{"WHILE",SimPasParser.WHILE},
{"IF",SimPasParser.IF},
{"THEN",SimPasParser.THEN},
{"ELSE",SimPasParser.ELSE},
{"REPEAT",SimPasParser.REPEAT},
{"UNTIL",SimPasParser.UNTIL},
{"DIV",SimPasParser.DIV},
{"MOD",SimPasParser.MOD},
{"AND",SimPasParser.AND},
{"NOT",SimPasParser.NOT},
{"OR",SimPasParser.OR},
{"ARRAY",SimPasParser.ARRAY},
{"OF",SimPasParser.OF},
{"RECORD",SimPasParser.RECORD}};
}



prog : declarations compoundStatement '.'
     ;

declarations : (constDefs| typeDefs| varDefs|procDefs)* ;

constDefs:  CONST constDef(';'constDef) ;
constDef:   //varDef '=' ordinaryConst ';'
        ID'=' constant
        |
        ;

typeDefs: TYPE typeDefList;
typeDefList: typeDef(';'typeDef);
typeDef:  ID'='typeSpecifer
       |
       ;
varDefs:    VAR varDefList;
varDefList:varDef(';'varDef)* ;
varDef: idList ':' typeSpecifer
      |
      ;

idList: ID ( ',' ID )*;
          
/*
Types in Pascal language includes ordinary types and complex types.
ordinary types are integers (including chars) enumerates, and subranges,
and complex types can be floats, arrays, and records.
We call arrays and records are composite types.
an ordinary type identifer can be a subrange of a definition 
of an array's dimension. This is my own understanding of Pascal language.

I think it is bad idea that colons are used to seperate sentences, so i make colons
a part of the sentence or definition in most cases.
*/

ordinaryType:'('idList')' ///enumerate type
            | (ordinaryConst|ID) '..' (ordinaryConst|ID)//subrange type
            ;

ordinaryTypeOrID: ordinaryType
                | ID
                ;

typeSpecifer: ordinaryTypeOrID
            | ARRAY '[' ordinaryTypeOrID (','ordinaryTypeOrID)*']' OF typeSpecifer
            | RECORD varDefList END
            ;

procDefs : procHeader declarations compoundStatement
         ;
funcDefs : funcHeader declarations compoundStatement
         ;


		 //':'TypeSpecifer
procHeader : PROCEDURE ID ('(' varDefList')')? ';' 
           ;

funcHeader : FUNCTION ID('(' varDefList')')?':'typeSpecifer;

compoundStatement:BEGIN statementList END
                 ;

statementList : statement (';' statement)*
              ;

statement : variable (':=' expression)?
          | FOR ID ':=' expression TO expression DO statement
          | FOR ID ':=' expression DOWNTO expression DO statement
          | WHILE expression DO statement
          | REPEAT statementList UNTIL expression
          | IF expression THEN statement
          | (BREAK | CONTINUE )
          | compoundStatement 
          |
          ;

/*variable : ID
         | ID'.'variable
         | ID '[' expressionList ']'
         ;
*/

variable : ID (('.'ID)|('['expressionList']')|('('expressionList')'))*
         ;
//ID.ID[]   an array member
//ID.ID()   a member function
//ID.ID.ID  trivial
//ID[][]    multidimension array
//ID[].ID   an array of records
//ID[]()    an array of function pointers
//ID()[]    ID() returns an array
//ID()()    ID() returns a function pointer
//ID().ID   ID() returns a record

expression : simpleExpression(('='|'<>'|'<'|'<='|'>'|'>=') simpleExpression)?
           ;

simpleExpression : term(('+'|'-'|OR) term )*
                 ;

term : factor (('*'|'/'|'div'|'mod'|'and') factor)*
     ;

factor : '('expression')'
       | NOT factor
       | variable
       | constant
       ;

expressionList : expression(','expression)*
               ;

functionCall : variable'('expressionList')'
             ;


constant : ordinaryConst
      ;
ordinaryConst: INT_CONST
              //|CHAR_CONST
              ;

INT_CONST:[0-9]+;
ID : [A-Za-z_]([A-Za-z_0-9])*
     {
	 if (keywords.ContainsKey(_localctx.GetText().ToUpper()))
                {
		     _localctx. setType (keywords[_localctx.GetText().ToUpper()]); // reset token type
		    }

    /*if ( keywords.containsKey(getText().toUpperCase()) ) {
     setType(keywords.get(getText().toUpperCase())); // reset token type
    }*/
	}
   ;

WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines
