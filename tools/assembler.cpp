#include <iostream>
#include <sstream>
#include <fstream>
#include <iomanip>
#include <map>
#include <set>
#include <vector>
#include <string>
#include <cstring>
#include <assert.h>
using namespace std;

struct asm_t {
	int r_num, v_num;
	string form, opcd, s1, s2;
	asm_t(int r_num, int v_num, const char *form, const char *opcd, const char *s1, const char *s2)
		: r_num(r_num), v_num(v_num), form(form), opcd(opcd), s1(s1), s2(s2) {}
	asm_t() { asm_t(0, 0, "", "", "", ""); }
};

# define MAX_LINE 10000000

map<string, string> reg;
map<string, asm_t> asmb;
set<string> nop_f, nop_o, nop_io;
bool dump_enable = false;
bool dump_bin_enable = false;
bool add_nop = true;
int alu_nop = 1;
int fpu_nop = 7;
int other_nop = 6;
int io_nop = 7;
int addr_line[MAX_LINE];

void remove_comment(string &cmd){
	for(int i = 0; i < cmd.size(); i++) if(cmd[i] == '#') {cmd = cmd.substr(0, i); break;};
}

void remove_comma(string &cmd){
	for(int i = 0; i < cmd.size(); i++) if(cmd[i] == ',') cmd[i] = ' ';
}

void remove_spaces(string &cmd){
	while(!cmd.empty()){
		if(cmd[0] == ' ' || cmd[0] == '\t') cmd.erase(0, 1);
		else break;
	}
	int m = cmd.size()-1;
	while(m >= 0 && (cmd[m] == ' ' || cmd[m] == '\t')){
		cmd.erase(m--, 1);
	}
}

void push_nop(vector<string> &s, int &addr, int n){
	addr += n;
	while(n--) s.push_back("nop");
}

int num_nop(string &s){
	if(s == "nop") return 0;
	if(s == "beq" || s == "bne") return 0;
	if(nop_f.find(s)!=nop_f.end()) return fpu_nop;
	if(nop_io.find(s)!=nop_io.end()) return io_nop;
	if(nop_o.find(s)!=nop_o.end()) return other_nop;
	return alu_nop;
}

string get_op(string &s){
	string res;
	stringstream ss(s);
	ss>>res;
	return res;
}

void decode_li(vector<string> &inst, int &addr, string &reg, unsigned int data){
	if(data < (1u<<16)){
		inst.push_back("ori " + reg + " $zero " + to_string(data));
		addr += 1;
	} else if(-(1<<15) <= (int)data && (int)data < 0){
		inst.push_back("addi " + reg + " $zero " + to_string((int)data));
		addr += 1;
	} else {
		inst.push_back("ori " + reg + " $zero " + to_string(data>>16));
		inst.push_back("sll " + reg + " " + reg + " 16");
		addr += 2;
		if(data&0xffff){
			inst.push_back("ori " + reg + " " + reg + " " + to_string(data&0xffff));
			addr += 1;
		}
	}
}

int init_inst(string &cmd, int &addr, map<string, int> &lab, map<string, int> &dlab, vector<string> &inst, string &dstr, bool &tmode){
	remove_comment(cmd);
	remove_spaces(cmd);
	if(cmd.empty()) return 0;
	if(cmd[cmd.size()-1] == ':'){
		assert(lab.count(cmd) == 0);
		if(tmode) lab[cmd.substr(0, cmd.size()-1)] = addr;
		else dstr = cmd.substr(0, cmd.size()-1);
		return 0;
	}
	if(cmd == ".text"){
		tmode = true;
		return 0;
	}
	if(cmd == ".data"){
		tmode = false;
		return 0;
	}
	if(cmd.substr(0, 5) == ".long"){
		stringstream ss(cmd.substr(5));
		ss.unsetf(ios::dec);
		unsigned int data;
		ss >> data;
		dlab[dstr] = data;
		return 0;
	}
	if(cmd[0] == '.'){
		return 0;
	}
	assert(tmode);

	remove_comma(cmd);
	if(cmd.substr(0, 3) == "llw"){
		stringstream ss(cmd.substr(3));
		string reg, data_l;
		ss >> reg >> data_l;
		unsigned int data = dlab[data_l.substr(1, data_l.size()-2)];
		decode_li(inst, addr, reg, data);
		return 0;
	}
	if(cmd.substr(0, 2) == "li"){
		stringstream ss(cmd.substr(2));
		string reg;
		unsigned int data;
		ss.unsetf(ios::dec);
		ss >> reg >> data;
		decode_li(inst, addr, reg, data);
		return 0;
	}
	string op = get_op(cmd);
	if(add_nop && (op=="rsb" || op=="rrb")) push_nop(inst, addr, 7);
	inst.push_back(cmd);
	addr += 1;
	if(add_nop) push_nop(inst, addr, num_nop(op));
	return 0;
}

void neg(string &s){
	int n = s.size();
	bool fs = true;
	for(int i = n-1; i >= 0; i--){
		if(fs){
			if(s[i]=='1') fs = false;
			continue;
		}
		s[i] = '0'+'1'-s[i];
	}
}

string i2b(int a, int n){
	string s(n, '0');
	for(int i = 0; i < n; i++){
		if(1&(a>>(n-i-1))) s[i] = '1';
	}
	return s;
}

void d2b(string &s, int n){
	stringstream ss(s);
	ss.unsetf(ios::dec);
	int a;
	ss >> a;
	s = i2b(a, n);
}

void d2b(string &s){
	d2b(s, 16);
}

void reg2i(string &s){
	if(s == "$zero") s = "00000";
	else if(s == "$at") s = "00001";
	else if(s == "$v0") s = "00010";
	else if(s == "$v1") s = "00011";
	else if(s == "$a0") s = "00100";
	else if(s == "$a1") s = "00101";
	else if(s == "$a2") s = "00110";
	else if(s == "$a3") s = "00111";
	else if(s == "$t0") s = "01000";
	else if(s == "$t1") s = "01001";
	else if(s == "$t2") s = "01010";
	else if(s == "$t3") s = "01011";
	else if(s == "$t4") s = "01100";
	else if(s == "$t5") s = "01101";
	else if(s == "$t6") s = "01110";
	else if(s == "$t7") s = "01111";
	else if(s == "$s0") s = "10000";
	else if(s == "$s1") s = "10001";
	else if(s == "$s2") s = "10010";
	else if(s == "$s3") s = "10011";
	else if(s == "$s4") s = "10100";
	else if(s == "$s5") s = "10101";
	else if(s == "$s6") s = "10110";
	else if(s == "$s7") s = "10111";
	else if(s == "$t8") s = "11000";
	else if(s == "$t9") s = "11001";
	else if(s == "$k0") s = "11010";
	else if(s == "$k1") s = "11011";
	else if(s == "$gp") s = "11100";
	else if(s == "$sp") s = "11101";
	else if(s == "$fp") s = "11110";
	else if(s == "$ra") s = "11111";
	else if(s.substr(0, 2) == "$r"){ s = s.substr(2); d2b(s, 5); }
}

void dis2ri(string &s, string &t){
	int sz = s.size();
	int ps = 0;
	while(ps<sz && s[ps]!='(') ps++;
	t = s.substr(0, ps);
	stringstream ss(t), ss2;
	int a;
	ss >> a;
	a = (a+(1<<16))&((1<<16)-1);
	ss2 << a;
	t = ss2.str();
	d2b(t);
	s = s.substr(ps+1, sz-ps-2);
	reg2i(s);
}

string assemble(string &cmd, int addr, map<string, int> &label){
	stringstream ss(cmd);
	string op, r[3];
	ss >> op;
	if(op == "nop"){
		return "00000000000000000000000000000000";
	}
	if(op == "hlt"){
		return "11110000000000000000000000000000";
	}
	if (op == "brk"){
		return "11110100000000000000000000000000";
	}
	if(op == "la"){
		string reg, addr_l;
		ss >> reg >> addr_l;
		reg2i(reg);
		assert(label.count(addr_l));
		assert(label[addr_l]<1<<16);
		return "00110100000" + reg + i2b(label[addr_l], 16);
	}
	const asm_t &as = asmb[op];

	for(int i = 0; i < as.v_num; i++){
		ss >> r[i];
		if(as.r_num == -2){
			if(i==0) reg2i(r[i]);
			if(i==1) dis2ri(r[i], r[i+1]);
		} else if(i >= as.r_num && as.form == "R"){
			d2b(r[i], 5);
		} else if(as.form == "B"){
			if(i==2){
				if(!label.count(r[i])) cerr<<label[r[i]]<<" "<<addr<<endl;
				assert(label.count(r[i]));
				r[i] = i2b(label[r[i]]-addr-1, 16);
			} else reg2i(r[i]);
		} else if(as.form == "J"){
			assert(label.count(r[i]));
			r[i] = i2b(label[r[i]], 26);
		} else (i < as.r_num ? reg2i : static_cast<void (*)(string &)>(d2b))(r[i]);
	}
	if(op == "subi"){
		neg(r[2]);
	}
	if(op == "move"){
		r[2] = "0";
		d2b(r[2]);
	}
	if(as.form == "R"){
		if(as.r_num == 3 || op == "jr") return as.opcd + r[1] + r[2] + r[0] + as.s1 + as.s2;
		else if(as.v_num == 2) return as.opcd + r[1] + "00000" + r[2] + r[0] + as.s1 + as.s2;
		else return as.opcd + "00000" + r[1] + r[0] + r[2] + as.s2;
	} else if(op == "rsb"){
		return as.opcd + r[0] + "00000" + "0000000000000000";
	} else if(op == "rrb"){
		return as.opcd + "00000" + r[0] + "0000000000000000";
	} else if(as.form == "I" || as.form == "B") return as.opcd + r[1] + r[0] + r[2];
	else if(as.form == "J") return as.opcd + r[0];
	else return "";
}

void init_setting(){
	asmb["add"] = asm_t(3, 3, "R", "000000", "00000", "100000");
	asmb["addi"] = asm_t(2, 3, "I", "001100", "", "");
	asmb["sub"] = asm_t(3, 3, "R", "000000", "00000", "100010");
	asmb["ori"] = asm_t(2, 3, "I", "001101", "", "");
	asmb["sw"] = asm_t(-2, 2, "I", "101011", "", "");
	asmb["lw"] = asm_t(-2, 2, "I", "100011", "", "");
	asmb["slt"] = asm_t(3, 3, "R", "000000", "00000", "101010");
	asmb["fslt"] = asm_t(3, 3, "R", "000000", "00000", "101011");
	asmb["beq"] = asm_t(2, 3, "B", "000100", "", "");
	asmb["bne"] = asm_t(2, 3, "B", "000101", "", "");
	asmb["fneg"] = asm_t(2, 2, "R", "000000", "00000", "101100");
	asmb["sll"] = asm_t(2, 3, "R", "000000", "", "000000");
	asmb["srl"] = asm_t(2, 3, "R", "000000", "", "000010");
	asmb["j"] = asm_t(0, 1, "J", "000010", "", "");
	asmb["jr"] = asm_t(1, 1, "R", "000000", "000000000000000", "001000");
	asmb["jal"] = asm_t(0, 1, "J", "000011", "", "");
	asmb["rsb"] = asm_t(1, 1, "I", "111111", "", "");
	asmb["rrb"] = asm_t(1, 1, "I", "111110", "", "");
	asmb["fadd"] = asm_t(3, 3, "R", "001011", "00000", "100000");
	asmb["fmul"] = asm_t(3, 3, "R", "001011", "00000", "000001");
	asmb["finv"] = asm_t(2, 2, "R", "001011", "00000", "000011");
	asmb["fsqrt"] = asm_t(2, 2, "R", "001011", "00000", "011000");
	asmb["f2i"] = asm_t(2, 2, "R", "001011", "00000", "101101");
	asmb["i2f"] = asm_t(2, 2, "R", "001011", "00000", "101110");
	asmb["flr"] = asm_t(2, 2, "R", "001011", "00000", "101111");

	asmb["subi"] = asm_t(2, 3, "I", "001100", "", "");
	asmb["move"] = asm_t(2, 2, "I", "001101", "", "");

	nop_f = set<string>({"fadd", "fmul", "finv", "fsqrt", "f2i", "i2f", "flr"});
	nop_o = set<string>({"lw"});
	nop_io = set<string>({"rsb", "rrb"});
	//nop_sw = set<string>({"sw"});
}

int run(int argc, char *argv[]){
	string in_name("a.s"), out_name("a.t");
	for(int i = 1; i < argc; i++){
		if(!strcmp(argv[i], "-i")) in_name = argv[++i];
		if(!strcmp(argv[i], "-o")) out_name = argv[++i];
		if(!strcmp(argv[i], "--dump")) dump_enable = true;
		if(!strcmp(argv[i], "--nodump")) dump_enable = false;
		if(!strcmp(argv[i], "--bin")) dump_bin_enable = true;
		if(!strcmp(argv[i], "--nobin")) dump_bin_enable = false;
		if(!strcmp(argv[i], "--nop")) add_nop = true;
		if(!strcmp(argv[i], "--nonop")) add_nop = false;
	}

	init_setting();
	ifstream fin(in_name);
	ofstream fout(out_name);

	string command;
	int addr = 0, addri = 0;
	int line = 1;
	map<string, int> label, dlabel;
	string dstr;
	bool tmode = true;
	vector<string> inst;
	while(getline(fin, command)){
		init_inst(command, addr, label, dlabel, inst, dstr, tmode);
		while(addri < addr) addr_line[addri++] = line;
		line++;
	}
	for(int i = 0; i < inst.size(); i++){
		if(dump_enable){
			cerr << "0x" << hex << setw(5) << setfill('0') <<  i << " -> " << dec << setw(6) << setfill(' ') << addr_line[i];
			if(dump_bin_enable) cerr << ": " << assemble(inst[i], i, label);
			cerr<< " # " + inst[i] << endl;
		}
		fout << assemble(inst[i], i, label) + "\n";
	}
	return 0;
}

int main(int argc, char *argv[]){
	run(argc, argv);
	return 0;
}
