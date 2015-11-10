#include <iostream>
#include <map>
#include <string>
#include <string.h>
#include <assert.h>
using namespace std;

map<string, string> b2h;

void init(){
	b2h["0000"] = "0";
	b2h["0001"] = "1";
	b2h["0010"] = "2";
	b2h["0011"] = "3";
	b2h["0100"] = "4";
	b2h["0101"] = "5";
	b2h["0110"] = "6";
	b2h["0111"] = "7";
	b2h["1000"] = "8";
	b2h["1001"] = "9";
	b2h["1010"] = "A";
	b2h["1011"] = "B";
	b2h["1100"] = "C";
	b2h["1101"] = "D";
	b2h["1110"] = "E";
	b2h["1111"] = "F";
}

int main(int argc, char *argv[]){
	bool hex = true;
	for(int i = 1; i < argc; i++){
		if(!strcmp(argv[i], "-b")) hex = false;
	}
	init();
	string s;
	while(cin >> s){
		assert(s.size()==32);
		string t = "\t";
		if(hex){
			t += "x\"";
		   	for(int i = 0; i < 8; i++) t += b2h[s.substr(4*i, 4)];
			t += "\",";
		}
		else t += "\"" + s + "\",";
		cout << t << endl;
	}
	cout << "\tothers => (others => '0')" << endl;
	
	return 0;
}
