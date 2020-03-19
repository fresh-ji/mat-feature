
#include "mex.h"
#include <tchar.h>
#include <Windows.h>
#include <stdio.h>

// 回调定义
void initTool(double, double);
void setToTool(double, char*, void*);
void setFinish(double);
void endTool();

// 变量定义
static char* token;
static int endFlag;

// 1
typedef char*(*FunDLL1)(char*,
        void(*initTool)(double, double),
        void(*setToTool)(double, char*, void*),
        void(*setFinish)(double),
        void(*endTool));
FunDLL1 startFun;
// 2
typedef int(*FunDLL2)(char*, char*, void*);
FunDLL2 setFun;
// 3
typedef int(*FunDLL3)(char*);
FunDLL3 advanceFun;
// 4
typedef int(*FunDLL4)(char*);
FunDLL4 endFun;

// 回调声明
void initTool(double startTime, double step) {
    printf("i should start at %f and step is %f\n", startTime, step);
    advanceFun(token);
}

void setToTool(double time, char* name, void* data) {
    printf("i received data at %f for %s\n", time, name);
}

void setFinish(double time) {
    printf("i did something and go forward to %f\n", time);
    advanceFun(token);
}

void endTool() {
    endFun(token);
    printf("i am over\n");
    endFlag = 1;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    DWORD err = 0;
    
    HMODULE hInstC = LoadLibraryEx(_T("spliceForTool"),
            NULL, LOAD_WITH_ALTERED_SEARCH_PATH);
    if (hInstC == NULL) {
        err = GetLastError();
        mexPrintf("load dll fail : %d\n", err);
        plhs[0] = mxCreateDoubleScalar(0);
        FreeLibrary(hInstC);
        return;
    }
    mexPrintf("load success!\n");
    
    startFun = (FunDLL1)GetProcAddress(hInstC, "dllStart");
    setFun = (FunDLL2)GetProcAddress(hInstC, "dllSetValue");
    advanceFun = (FunDLL3)GetProcAddress(hInstC, "dllAdvance");
    endFun = (FunDLL4)GetProcAddress(hInstC, "dllEnd");
    
    token = startFun("ZtOE0Jfu_insA.xml",
            initTool, setToTool, setFinish, endTool);
    if("" == token) {
        err = GetLastError();
        mexPrintf("start dll fail : %d\n", err);
        plhs[0] = mxCreateDoubleScalar(0);
        FreeLibrary(hInstC);
        return;
    }
    mexPrintf("start success!\n");
    
    while (1) {
        Sleep(300);
        if (endFlag == 1) {
            FreeLibrary(hInstC);
            break;
        }
    }
    
    mexPrintf("everything fine!\n");
    return;
}
