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

<YYINITIAL> "if"     { /*return symbolFactory.newSymbol("IF" ,IF);*/ System.out.println("IF"); }
<YYINITIAL> "else"   { /*return symbolFactory.newSymbol("ELSE" ,ELSE);*/ System.out.println("ELSE"); }
<YYINITIAL> "while"  { /*return symbolFactory.newSymbol("WHILE" ,WHILE);*/ System.out.println("WHILE"); }
<YYINITIAL> "return" { /*return symbolFactory.newSymbol("RETURN" ,RETURN);*/ System.out.println("RETURN"); } 
<YYINITIAL> "void"   { /*return symbolFactory.newSymbol("VOID" ,VOID);*/  System.out.println("VOID"); }
<YYINITIAL> "int"	 { /*return symbolFactory.newSymbol("INT" , INT);*/ System.out.println("INT"); }
<YYINITIAL> {
  {Identifier} { /*return symbolFactory.newSymbol("IDENTIFIER",IDENTIFIER);*/ System.out.println("IDENTIFIER(" + yytext() + ")"); }
  {Comment}    {							  }
  {Whitespace} {                              }
  ";"          { /*return symbolFactory.newSymbol("SEMI", SEMI);*/ System.out.println("SEMI"); }
  "+"          { /*return symbolFactory.newSymbol("PLUS", PLUS);*/ System.out.println("PLUS"); }
  "-"          { /*return symbolFactory.newSymbol("MINUS", MINUS);*/ System.out.println("MINUS"); }
  "*"          { /*return symbolFactory.newSymbol("TIMES", TIMES);*/ System.out.println("TIMES"); }
  "/"          { /*return symbolFactory.newSymbol("DIVIDE", DIVIDE);*/ System.out.println("DIVIDE"); }
  "n"          { /*return symbolFactory.newSymbol("UMINUS", UMINUS);*/ System.out.println("UMINUS"); }
  "("          { /*return symbolFactory.newSymbol("LPAREN", LPAREN);*/ System.out.println("LPAREN"); }
  ")"          { /*return symbolFactory.newSymbol("RPAREN", RPAREN);*/ System.out.println("RPAREN"); }
  {Number}     { /*return symbolFactory.newSymbol("NUMBER", NUMBER, Integer.parseInt(yytext()));*/ System.out.println("Number(" + Integer.parseInt(yytext()) + ")"); }
  "{" 		   { /*return symbolFactory.newSymbol("LBRACE", LBRACE);*/ System.out.println("LBRACE"); }
  "}"          { /*return symbolFactory.newSymbol("RBRACE", RBRACE);*/ System.out.println("RBRACE"); }
  "["		   { /*return symbolFactory.newSymbol("LBRACKET" ,LBRACKET);*/ System.out.println("LBRACKET"); }
  "]"		   { /*return symbolFactory.newSymbol("RBRACKET" ,RBRACKET);*/ System.out.println("RBRACKET"); }
  ","		   { /*return symbolFactory.newSymbol("COMMA", COMMA);*/ System.out.println("COMMA"); }
  "<"		   { /*return symbolFactory.newSymbol("LESSTHAN", LESSTHAN);*/ System.out.println("LESSTHAN"); }
  ">"		   { /*return symbolFactory.newSymbol("GREATERTHAN", GREATERTHAN);*/ System.out.println("GREATERTHAN"); }
  "<="		   { /*return symbolFactory.newSymbol("LESSEQTHAN", LESSEQTHAN);*/ System.out.println("LESSEQTHAN"); }
  ">="		   { /*return symbolFactory.newSymbol("GREATEREQTHAN", GREATEREQTHAN);*/ System.out.println("GREATEREQTHAN"); }
  "=="		   { /*return symbolFactory.newSymbol("EQUAL", EQUAL);*/ System.out.println("EQUAL"); }
  "!="		   { /*return symbolFactory.newSymbol("DIFFTHAN", DIFFTHAN);*/ System.out.println("DIFFTHAN"); }
  "="          { /*return symbolFactory.newSymbol("SET", SET);*/ System.out.println("SET"); }
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" + yytext() + "' -- ignored"); }
([I][nN][tT][ \n\r*]) | ([iI][N][tT][ \n\r*]) | ([iI][nN][T][ \n\r*]) { emit_warning("It is not of int type '" + yytext() + "' -- ignored");}
([I][fF][ \n\r*]) | ([iI][F][ \n\r]*) { emit_warning("If is not typed like that " + yytext() + " ' --ignored"); }
([V][oO][iI][dD][ \n\r*]) | ([vV][O][iI][dD][ \n\r*]) | ([vV][oO][I][dD][ \n\r*]) | ([vV][oO][iI][D][ \n\r*]) { emit_warning( "Void is not typed like that '" + yytext() + "' --ignored "); }
([E][lL][sS][eE][ \n\r*]) | ([eE][L][sS][eE][ \n\r*]) | ([eE][lL][S][eE][ \n\r*]) | ([eE][lL][sS][E][ \n\r*]) { emit_warning( "Else is not typed like that '" + yytext() + "' --ignored "); }
([W][hH][iI][lL][eE][ \n\r*]) | ([wW][H][iI][lL][eE][ \n\r*]) | ([wW][hH][I][lL][eE][ \n\r*]) | ([wW][hH][iI][L][eE][ \n\r*]) | ([wW][hH][iI][lL][E][ \n\r*]) { emit_warning( "While is not typed like that '" + yytext() + "' --ignored "); }
([R][eE][tT][uU][rR][nN][ \n\r*]) | ([rR][E][tT][uU][rR][nN][ \n\r*]) | ([rR][eE][T][uU][rR][nN][ \n\r*]) | ([rR][eE][tT][U][rR][nN][ \n\r*]) | ([rR][E][tT][uU][R][nN][ \n\r*]) | ([rR][E][tT][uU][rR][N][ \n\r*]) { emit_warning ( "Return is not typed like that '" + yytext() + "' --ignored "); }  