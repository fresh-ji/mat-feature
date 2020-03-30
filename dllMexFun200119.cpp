
#include "mex.h"
#include <tchar.h>
#include <Windows.h>
#include <stdio.h>

// 回调定义
void initTool(double, double);
void setToTool(double, char*, void*);
void setFinish(double);
void endTool();

// 1
typedef char*(*FunDLL1)(char*,
        void(*initTool)(double, double),
        void(*setToTool)(double, char*, void*),
        void(*setFinish)(double),
        void(*endTool));
FunDLL1 startFun;
// 2
typedef int(*FunDLL2)(char*, void*);
FunDLL2 setFun;
// 3
typedef int(*FunDLL3)();
FunDLL3 advanceFun;
// 4
typedef int(*FunDLL4)();
FunDLL4 endFun;

// test
typedef void(*FunDLL5)();
FunDLL5 testInit;
typedef void(*FunDLL6)();
FunDLL6 testData;
typedef void(*FunDLL7)();
FunDLL7 testFinish;

// 回调声明
void initTool(double startTime, double step) {
    mxArray* pattern = mxCreateString("init");
    mxArray * param1 = mxCreateDoubleMatrix(1, 1, mxREAL);
    *(mxGetPr(param1)) = startTime;
    mxArray * param2 = mxCreateDoubleMatrix(1, 1, mxREAL);
    *(mxGetPr(param2)) = step;
    mxArray* param3 = mxCreateString("empty");
    mxArray * args [] = { pattern, param1, param2, param3 };
    mexCallMATLABWithTrap(0, NULL, 4, args, "processByMatlab");
    advanceFun();
}

void setToTool(double time, char* name, void* data) {
    mxArray* pattern = mxCreateString("data");
    mxArray * param1 = mxCreateDoubleMatrix(1, 1, mxREAL);
    *(mxGetPr(param1)) = time;
    mxArray* param2 = mxCreateString((const char *)name);
    mxArray* param3 = mxCreateString((const char *)data);
    mxArray * args [] = { pattern, param1, param2, param3 };
    mexCallMATLABWithTrap(0, NULL, 4, args, "processByMatlab");
}

void setFinish(double time) {
    mxArray* pattern = mxCreateString("push");
    mxArray* param1 = mxCreateString("empty");
    mxArray* param2 = mxCreateString("empty");
    mxArray* param3 = mxCreateString("empty");
    mxArray * args [] = { pattern, param1, param2, param3 };
    mexCallMATLABWithTrap(0, NULL, 4, args, "processByMatlab");
    advanceFun();
}

void endTool() {
    endFun();
    printf("----- i am over! -----\n");
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    int x = (int)mxGetScalar(prhs[0]);
    
    if(1 == x) {
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
        mexPrintf("----- load success! -----\n");
        
        startFun = (FunDLL1)GetProcAddress(hInstC, "dllStart");
        setFun = (FunDLL2)GetProcAddress(hInstC, "dllSetValue");
        advanceFun = (FunDLL3)GetProcAddress(hInstC, "dllAdvance");
        endFun = (FunDLL4)GetProcAddress(hInstC, "dllEnd");
        
        testInit = (FunDLL5)GetProcAddress(hInstC, "matInit");
        testData = (FunDLL6)GetProcAddress(hInstC, "matData");
        testFinish = (FunDLL7)GetProcAddress(hInstC, "matFinish");
        
        static char* token = startFun("Inka6XNh_insA.xml",
                initTool, setToTool, setFinish, endTool);
        if("" == token) {
            err = GetLastError();
            mexPrintf("start dll fail : %d\n", err);
            plhs[0] = mxCreateDoubleScalar(0);
            FreeLibrary(hInstC);
            return;
        }
        mexPrintf("----- start success! -----\n");
        
        testInit();
        testData();
        testFinish();
        
        return;
    }
    else if(2 == x) {
        endFun();
        printf("----- i am over! -----\n");
    }
}
