/*
I'm level 1 test.
*/
int main() {
    int a, s;
    a = 10;
    s = 10;
    char ch;
    scanf("%c", &ch);
    printf("%c\n",ch);
    while(a>0 && a<=10 ||a%100==0) {
        a -= 1;
	printf("a is: %d\n", a);
        int a;
        a = 10;
        s += a;
        if(s != 10) {
            printf("result is: %d\n", s);
            int b;
            b = 10;
            for(int i=0; i<b; i++) {
                printf("Have fun: %d\n", i);
            }
        }
    }
}
// No more compilation error.
