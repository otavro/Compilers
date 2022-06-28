/* Nao usar a biblioteca do flex*/
%option noyywrap

%{
	#include <string.h>
	int totalLines = 1;
	int lineChar = 1;
	int first = 0;
	int lastLines =1;
	int lastChar = 1;

	void plprintf(char frase[100]){
		if(first == 0){
			printf("%s",frase);
			first = 1;
		}
		else{
			printf("\n%s",frase);
		}
	}
	void ptprintf(char frase[100], char texto[]){
		if(first == 0){
			printf("%s(%s)", frase, texto);
			first = 1;
		}
		else{
			printf("\n%s(%s)",frase, texto);
		}
	}
	void printString(char frase[100], char texto[]){
		char *result = texto+1;
		result[strlen(result)-1] = '\0';
		if(first == 0){
			printf("%s(%s)", frase, result);
			first = 1;
		}
		else{
			printf("\n%s(%s)",frase, result);
		}
	}
%}

%x COMMENT

%%
" "		{lineChar++;}
"//".*"\n"					{lineChar = 1; totalLines++;}
"/*"						{lastLines = totalLines; lastChar = lineChar; lineChar+=2; BEGIN(COMMENT);}
"void"						{plprintf("VOID"); lineChar+=strlen(yytext);}
"int"						{plprintf("INT"); lineChar+=strlen(yytext);}
"char"						{plprintf("CHAR"); lineChar+=strlen(yytext);}
"return"					{plprintf("RETURN"); lineChar+=strlen(yytext);}
"break"					{plprintf("BREAK"); lineChar+=strlen(yytext);}
"switch"					{plprintf("SWITCH"); lineChar+=strlen(yytext);}
"case"						{plprintf("CASE"); lineChar+=strlen(yytext);}
"default"					{plprintf("DEFAULT"); lineChar+=strlen(yytext);}
"do"						{plprintf("DO"); lineChar+=strlen(yytext);}
"while"						{plprintf("WHILE"); lineChar+=strlen(yytext);}
"for"						{plprintf("FOR"); lineChar+=strlen(yytext);}
"if"						{plprintf("IF"); lineChar+=strlen(yytext);}
"else"						{plprintf("ELSE"); lineChar+=strlen(yytext);}
"typedef"					{plprintf("TYPEDEF"); lineChar+=strlen(yytext);}
"struct"					{plprintf("STRUCT"); lineChar+=strlen(yytext);}
"+"							{plprintf("PLUS"); lineChar+=strlen(yytext);}
"-"							{plprintf("MINUS"); lineChar+=strlen(yytext);}
"*"							{plprintf("MULTIPLY"); lineChar+=strlen(yytext);}
"/"							{plprintf("DIV"); lineChar+=strlen(yytext);}
"%"							{plprintf("REMAINDER"); lineChar+=strlen(yytext);}
"++"						{plprintf("INC"); lineChar+=strlen(yytext);}
"--"						{plprintf("DEC"); lineChar+=strlen(yytext);}
"&"							{plprintf("BITWISE_AND"); lineChar+=strlen(yytext);}
"|"							{plprintf("BITWISE_OR"); lineChar+=strlen(yytext);}
"~"							{plprintf("BITWISE_NOT"); lineChar+=strlen(yytext);}
"^"							{plprintf("BITWISE_XOR"); lineChar+=strlen(yytext);}
"!"							{plprintf("NOT"); lineChar+=strlen(yytext);}
"&&"						{plprintf("LOGICAL_AND"); lineChar+=strlen(yytext);}
"||"						{plprintf("LOGICAL_OR"); lineChar+=strlen(yytext);}
"=="						{plprintf("EQUAL"); lineChar+=strlen(yytext);}
"!="						{plprintf("NOT_EQUAL"); lineChar+=strlen(yytext);}
"<"							{plprintf("LESS_THAN"); lineChar+=strlen(yytext);}
">"							{plprintf("GREATER_THAN"); lineChar+=strlen(yytext);}
"<="						{plprintf("LESS_EQUAL"); lineChar+=strlen(yytext);}
">="						{plprintf("GREATER_EQUAL"); lineChar+=strlen(yytext);}
">>"						{plprintf("R_SHIFT"); lineChar+=strlen(yytext);}
"<<"						{plprintf("L_SHIFT"); lineChar+=strlen(yytext);}
"="							{plprintf("ASSIGN"); lineChar+=strlen(yytext);}
"+="						{plprintf("ADD_ASSIGN"); lineChar+=strlen(yytext);}
"-="						{plprintf("MINUS_ASSIGN"); lineChar+=strlen(yytext);}
";"							{plprintf("SEMICOLON"); lineChar+=strlen(yytext);}
","							{plprintf("COMMA"); lineChar+=strlen(yytext);}
":"							{plprintf("COLON"); lineChar+=strlen(yytext);}
"("							{plprintf("L_PAREN"); lineChar+=strlen(yytext);}
")"							{plprintf("R_PAREN"); lineChar+=strlen(yytext);}
"{"							{plprintf("L_CURLY_BRACKET"); lineChar+=strlen(yytext);}
"}"							{plprintf("R_CURLY_BRACKET"); lineChar+=strlen(yytext);}
"["							{plprintf("L_SQUARE_BRACKET"); lineChar+=strlen(yytext);}
"]"							{plprintf("R_SQUARE_BRACKET"); lineChar+=strlen(yytext);}
"?"							{plprintf("TERNARY_CONDITIONAL"); lineChar+=strlen(yytext);}
"#"							{plprintf("NUMBER_SIGN"); lineChar+=strlen(yytext);}
"->"						{plprintf("POINTER"); lineChar+=strlen(yytext);}
"printf"					{plprintf("PRINTF"); lineChar+=strlen(yytext);}
"scanf"						{plprintf("SCANF"); lineChar+=strlen(yytext);}
"define"					{plprintf("DEFINE"); lineChar+=strlen(yytext);}
"exit"						{plprintf("EXIT"); lineChar+=strlen(yytext);}
"\n"   						{totalLines++; lineChar = 1;}

[_a-zA-Z][_a-zA-Z0-9]* 		{ptprintf("IDENTIFIER", yytext); lineChar+=strlen(yytext);}
"0"[1-7]+[0-7]*		 		{ptprintf("NUM_OCTAL", yytext); lineChar+=strlen(yytext);}
"0"[x|X][a-fA-F0-9]* 		{ptprintf("NUM_HEXA", yytext); lineChar+=strlen(yytext);}
[0-9][0-9]*					{ptprintf("NUM_INTEGER", yytext); lineChar+=strlen(yytext);}
\"(\\.|[^"\\])*\"			{printString("STRING", yytext); lineChar+=strlen(yytext);}
'([^'\\\n]|\\.)'			{printString("CHARACTER", yytext); lineChar+=strlen(yytext);}
\t							{lineChar += strlen(yytext);}
\r							{}
.							{printf("\nerror:lexical:%d:%d: %s\n",totalLines, lineChar, yytext); lineChar+=strlen(yytext);}


<COMMENT>{
"*/"  					{lineChar+=strlen(yytext); BEGIN(INITIAL);}
[^*\n]					{lineChar+=strlen(yytext);}
"*"       				{lineChar+=strlen(yytext);}
\n        			 	{lineChar = 1; totalLines++;} 
<<EOF>>  				{printf("\nerror:lexical:%d:%d: unterminated comment", lastLines, lastChar); exit(1);}
}

%%

int main(int argc, char **argv)
{
	yylex();
	return 0;
}
