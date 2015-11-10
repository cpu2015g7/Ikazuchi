#include <iostream>
#include <map>
#include <string>
#include <string.h>
#include <assert.h>
using namespace std;


int main(int argc, char *argv[]){
	for(int i = 1; i < argc; i++){
	}
	string s;
	while(cin >> s){
		assert(s.size()==32);
		unsigned char a = 0;
		for(int i = 0; i < 32; i++){
			a <<= 1;
			a |= s[i]-'0';
			if(i%8 == 7){
				cout << a;
				a = 0;
			}
		}
	}
	
	return 0;
}
