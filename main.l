%option noyywrap
%{
    #include"common.h"
    #include"main.tab.hh"
    int firstword = 0;
    extern vector<scope> scopes;//作用域向量
    extern vector<variable> work_scope;//当前作用域的变量表
    
    extern int scopeid;
    
%}

INTEGER 0|[1-9][0-9]*
CHARACTER \'(.*)\'
STRING \"(.*)\"
ID [[:alpha:]_][[:alpha:][:digit:]_]*
andID \&[[:alpha:]_][[:alpha:][:digit:]_]*
starID \*[[:alpha:]_][[:alpha:][:digit:]_]*

EOL (\r\n|\n)
WHITE [\t ]

commentblock "/*"
commentspace [ \t]
commentelement [^ \t\n]
commentnextline \n
commentend "*/"
commentline "//"
%x CBLOCK
%x CLINE

%%

"true" {
    TreeNode *node = new TreeNode(NODE_BOOL);
    node->bool_val = true;
    yylval = node;
    return TRUE;
}
"false" {
    TreeNode *node = new TreeNode(NODE_BOOL);
    node->bool_val = false;
    yylval = node;
    return FALSE;
}

"int" return INT;
"void" return VOID;
"char" return CHAR;
"string" return STR;
 
"for" return FOR;
"if" return IF;
"while" return WHILE;
"else" return ELSE;
"return" return RETURN;

"printf" return PRINTF;
"scanf" return SCANF;

"const" return CONST;

"." return dot;
"=" return ASSIGN;
"+=" return ADE;
"-=" return SUE;
"*=" return MUE;
"/=" return DIE;
"%=" return MOE;

"++" return ADO;
"--" return SUO;
"+" return ADD;
"-" return SUB;
"*" return MUL;
"/" return DIV;
"%" return MOD;

"!" return NOT;
"&&" return AND;
"||" return OR;
"==" return EQUAL;
"!=" return NEQUAL;
">" return GT;
">=" return GE;
"<" return LT;
"<=" return LE;

"," return COMMA;
";" return SEMICOLON;
"(" return SLB;
")" return SRB;
"[" return MLB;
"]" return MRB;
"{" {
    scopes.emplace_back(scope(work_scope, scopeid++));
    return LLB;
}
"}" return LRB;

{INTEGER} {
    TreeNode *node = new TreeNode(NODE_CONINT);
    node->int_val = atoi(yytext);
    node->varType = VAR_INTEGER;
    yylval = node;
    return INTEGER;
}
{CHARACTER} {
    TreeNode *node = new TreeNode(NODE_CONCHAR);
    node->int_val = int(string(yytext)[1]);
    node->varType = VAR_CHAR;
    yylval = node;
    return CHARACTER;
}
{STRING} {
    TreeNode *node = new TreeNode(NODE_CONSTR);
    string str = string(yytext);
    str.erase(0,str.find_first_not_of("\""));
    str.erase(str.find_last_not_of("\"") + 1);
    node->str_val = str;
    node->varType = VAR_STR;
    yylval = node;
    return STRING;
}
{ID} {
    TreeNode *node = new TreeNode(NODE_VAR);
    node->varName = string(yytext);
    vector<variable>::reverse_iterator it = work_scope.rbegin();
    while(it != work_scope.rend())
    {
        if((*it).name == node->varName)
        {
            node->varType = (*it).type;
            break;
        }
        it++;
    }
    yylval = node;
    return ID;
}
{andID} {
    TreeNode *node = new TreeNode(NODE_VAR);
    string str = string(yytext);
    str.erase(str.begin());
    node->varName = str;
    node->varFlag = VAR_ADDRESS;
    vector<variable>::reverse_iterator it = work_scope.rbegin();
    while(it != work_scope.rend())
    {
        if((*it).name == node->varName)
        {
            node->varType = (*it).type;
            break;
        }
        it++;
    }
    yylval = node;
    return ID;
}
{starID} {
    TreeNode *node = new TreeNode(NODE_VAR);
    string str = string(yytext);
    str.erase(str.begin());
    node->varName = str;
    node->varFlag = VAR_POINTER;
    vector<variable>::reverse_iterator it = work_scope.rbegin();
    while(it != work_scope.rend())
    {
        if((*it).name == node->varName)
        {
            node->varType = (*it).type;
            break;
        }
        it++;
    }
    yylval = node;
    return ID;
}
{EOL}
{WHITE}

{commentblock} { BEGIN CBLOCK; printf("# CBLOCK BEGIN\t"); }
<CBLOCK>{commentelement} { if(!firstword) printf("#\t"); printf("%s", yytext); firstword = 1; }
<CBLOCK>{commentspace} { if(firstword) printf("%s", yytext); }
<CBLOCK>{commentnextline} { printf("\n"); firstword = 0; }
<CBLOCK>{commentend} { printf("# CBLOCK END\n"); BEGIN INITIAL; }

{commentline} { BEGIN CLINE; printf("# CLINE START:"); }
<CLINE>{commentelement} { printf("%s", yytext); }
<CLINE>{commentspace} { printf("%s", yytext); }
<CLINE>{commentnextline} { printf("\n"); BEGIN INITIAL; }
%%