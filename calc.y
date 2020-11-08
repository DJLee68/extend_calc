/* The Bison declarations section */ 

%{ 
/* C declarations and #define statements go here */
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#define YYSTYPE double 
void yyerror(const char *);
int yylex(void);
double temp;
%}

%token NUMBER /* define token type for numbers */
%token BAR
%left '+' '-' /* + and - are left associative */
%left '*' '/' '%' /* * and / and % are left associative */
%right '^' /* ^ is right associative */

%% /* cal c grammar rules */

input   : /* empty production to allow an empty input */
        | input line
        ;

line    : expr '\n'     { temp=$1; printf("Result: %f\n", $1); temp=$1; }
        | '\n'     {}
        ;

expr    : expr '+' term { $$ = $1 + $3; }
        | expr '-' term { $$ = $1 - $3; }
        | term          { $$ = $1; }
        ;

/* if ($3 == 0) { yyerror("You can't divide by zero"); } else  */
term    : term '*' factor   { $$ = $1 * $3; }
        | term '/' factor   { $$ = $1 / $3; }
        | term '^' factor   { $$ = pow($1, $3); }
        | term '%' factor   { $$ = fmod($1, $3); }
        | factor            { $$ = $1; }
        ;

factor  : '(' expr ')'  { $$ = $2; }
        | NUMBER        { $$ = $1; }
        | '-' NUMBER    { $$ = -$2; }
        | '_'           { $$ = temp}
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
    /* fprintf(stderr, "error: %s\n", errmsg); */
} 

int main() {
    printf("type an expression:\n"); 
    yyparse(); 
} 

