#pragma once
#include<string>
#include<vector>
using namespace std;
class variable
{
public:
    int type;
    string name;
    int ro_index;
    vector<int> dim;
    variable()
    {
        this->type = 0;
        this->name = "";
    }
    variable(const variable& v)
    {
        this->type = v.type;
        this->name = v.name;
    }
    variable(int type, string name)
    {
        this->type = type;
        this->name = name;
    }
    variable(string name, int ro_index)
    {
        this->type = 4;
        this->ro_index = ro_index;
        this->name = name;
    }
};
class tmpvariable
{
public:
    variable v;
    int l;
    tmpvariable(variable v, int l)
    {
        this->v = variable(v.type, v.name);
        this->l = l;
    }
};
class scope
{
public:
    vector<variable> varies;
    int index;
    void output()
    {
        for(int i = 0;i < varies.size();i++)
        {
            printf("%s  %d\n", varies[i].name.c_str(), index);
        }
    }
    scope(vector<variable> varies, int index)
    {
        this->varies = varies;
        this->index = index;
    }
};
