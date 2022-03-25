%{
#include <string.h>
#include <ctype.h> 

#define MAX_SIZE_NAME 50
#define MAX_SIZE_TOURNAMENT 100

const char* genders[2]= {"WOMAN","MAN"};
 
enum { TITLE = 500, GENDER,PARTICIPANT_NAME,NAME,YEAR, COMMA, THROUGH, TOURNAMENT,APOSTROPHES,DOUBLE_STAR };
enum gender { WOMAN ,MAN } ;

union {
  int ival;
  char tournament[MAX_SIZE_TOURNAMENT];
  char name[MAX_SIZE_NAME];
  enum gender typeGender;
} yylval;


extern int atoi (const char *);

%}
%option noyywrap
%option yylineno

%%

"Winners" {return TITLE;}

18[5-9][0-9]|19[0-9]{2}|[2-9][0-9]{3,} { yylval.ival = atoi(yytext); return YEAR;}

["`'][a-zA-Z]+(" "[a-zA-Z]+)*["`'] {strcpy(yylval.name,yytext+1); yylval.name[strlen(yylval.name)-1]='\0';return PARTICIPANT_NAME;}

\<Woman\> {yylval.typeGender = WOMAN; return GENDER; }

\<Man\> {yylval.typeGender = MAN; return GENDER; }

\<name\> {return NAME;}

\<[a-zA-Z]+(" "[a-zA-Z]+)*\> { strcpy(yylval.tournament,yytext+1); yylval.tournament[strlen(yylval.tournament)-1]='\0'; return TOURNAMENT; }

"**" {return DOUBLE_STAR;}

","  {return COMMA;}

"-" {return THROUGH;}

[ \n\t\r]+  /* skip white space */

. {fprintf (stderr, "Line number : %d unrecognized token %c \n",yylineno,yytext[0]);}

%%

int main (int argc, char **argv)
{
   int token;

   if (argc != 2) {
      fprintf(stderr, "Usage: mylex %s\n", argv[0]);
      exit (1);
   }

   yyin = fopen (argv[1], "r");
   
   printf("\nTOKEN\t\t\tLEXEME\t\t\tSEMANTIC VALUE\n");
   printf("----------------------------------------------------------------\n");

   while ((token = yylex ()) != 0)
     switch (token) {
     
          case TITLE:  printf ("TITLE:\t\t\t%s\n", yytext);
	              break;
	  case GENDER:
	              printf ("GENDER:\t\t\t%s\t\t\t%s\n",yytext,genders[yylval.typeGender]);
	              break;
	  case THROUGH: printf("THROUGH:\t\t%s\t\t\n",yytext);
	              break;
	  case DOUBLE_STAR: printf("DOUBLE_STAR:\t\t%s\t\t\n",yytext);
	              break;
          case COMMA: printf("COMMA:\t\t\t%s\t\t\n",yytext);
	              break;
          case YEAR: printf("YEAR:\t\t\t%d\t\t\t%d\n", yylval.ival,yylval.ival);
	              break;
          case PARTICIPANT_NAME:  printf("NAME:\t\t\t%s\t\t%s\n", yytext,yylval.name);
                      break;
          case NAME:  printf("NAME:\t\t\t%s\n",yytext);
                      break;
          case TOURNAMENT:  printf("TOURNAMENT:\t\t%s\t\t%s\n", yytext,yylval.tournament);
                      break;
                      
         default:   fprintf (stderr, "error ... \n"); exit (1);
       } 
       
   fclose (yyin);
   exit (0);
}

