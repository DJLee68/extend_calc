/* The Bison declarations section */ 

%{ 
/* C declarations and #define statements go here */
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#define YYSTYPE double 
%}

%token NUMBER /* define token type for numbers */
%left '+' '-' /* + and - are left associative */
%% /* cal c grammar rules */

input   : /* empty production to allow an empty input */
        | input line
        ;

line    : expr '\n'     { printf("Result: %f\n", $1); }
        | error '\n'    { yyerrok; }
        ;

expr    : expr '+' term { $$ = $1 + $3; }
        | expr '-' term { $$ = $1 - $3; }
        | term          { $$ = $1; }
        ;

term    : NUMBER        { $$ = $1; }
        ;

%% 
int yylex (void) {
    int c = getchar(); /* read from stdin */
    if (c < 0) return 0; /* end of the input*/ 
    while (c == ' ' || c == '\t') c = getchar(); 
    if (isdigit(c) || c == '.') {
        ungetc(c, stdin); /* put c back into input */ 
        scanf("%lf",&yylval); /* get value using scanf */
        return NUMBER; /* return the token type */
    }
    return c; /* anything else... return char itself */ 
}

void yyerror(const char *errmsg) {
    printf("%s\n", errmsg); 
} 
int main() {
    printf("type an expression:\n"); 
    yyparse(); 
} 

