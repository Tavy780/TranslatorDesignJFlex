package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%char
%{
	

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

Newline    = \n | \r | \r\n 
Whitespace = [ \t\f] | {Newline}
Number     = 0 | [1-9][0-9]*

/* comments */
Comment = {TraditionalComment}
TraditionalComment = "/*" {CommentContent} \*+ "/"
CommentContent = ( [^*] | \*+[^*/] )*

Identifier = ([a-z] | [A-Z]) ([a-z] | [A-Z] | [0-9] | "_")*

%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> "if"     { return symbolFactory.newSymbol("IF" ,IF); }
<YYINITIAL> "else"   { return symbolFactory.newSymbol("ELSE" ,ELSE); }
<YYINITIAL> "while"  { return symbolFactory.newSymbol("WHILE" ,WHILE); }
<YYINITIAL> "return" { return symbolFactory.newSymbol("RETURN" ,RETURN);} 
<YYINITIAL> "void"   { return symbolFactory.newSymbol("VOID" ,VOID);}
<YYINITIAL> "int"	 { return symbolFactory.newSymbol("INT" , INT);}
<YYINITIAL> {
  {Identifier} { return symbolFactory.newSymbol("ID",ID, yytext());}
  {Comment}    {							  }
  {Whitespace} {                              }
  ";"          { return symbolFactory.newSymbol("SEMI", SEMI);}
  "+"          { return symbolFactory.newSymbol("PLUS", PLUS);}
  "-"          { return symbolFactory.newSymbol("MINUS", MINUS);}
  "*"          { return symbolFactory.newSymbol("TIMES", TIMES);}
  "/"          { return symbolFactory.newSymbol("DIVIDE", DIVIDE);}
  "n"          { return symbolFactory.newSymbol("UMINUS", UMINUS);}
  "("          { return symbolFactory.newSymbol("LPAREN", LPAREN);}
  ")"          { return symbolFactory.newSymbol("RPAREN", RPAREN);}
  {Number}     { return symbolFactory.newSymbol("NUM", NUM, Integer.parseInt(yytext()));}
  "{" 		   { return symbolFactory.newSymbol("LBRACE", LBRACE);}
  "}"          { return symbolFactory.newSymbol("RBRACE", RBRACE);}
  "["		   { return symbolFactory.newSymbol("LBRACKET" ,LBRACKET);}
  "]"		   { return symbolFactory.newSymbol("RBRACKET" ,RBRACKET);}
  ","		   { return symbolFactory.newSymbol("COMMA", COMMA);}
  "<"		   { return symbolFactory.newSymbol("LESSTHAN", LESSTHAN);}
  ">"		   { return symbolFactory.newSymbol("GREATERTHAN", GREATERTHAN);}
  "<="		   { return symbolFactory.newSymbol("LESSEQTHAN", LESSEQTHAN);}
  ">="		   { return symbolFactory.newSymbol("GREATEREQTHAN", GREATEREQTHAN);}
  "=="		   { return symbolFactory.newSymbol("EQUAL", EQUAL);}
  "!="		   { return symbolFactory.newSymbol("DIFFTHAN", DIFFTHAN);}
  "="          { return symbolFactory.newSymbol("SET", SET);}
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" + yytext() + "' -- ignored"); }
