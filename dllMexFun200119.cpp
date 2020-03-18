
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
static int stepNumber = 0;
static HMODULE hInstC = NULL;
static char* token;
int endFlag;
DWORD err = 0;

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
    
    if(stepNumber == 0) {
        
		hInstC = LoadLibraryEx(_T("spliceForTool"),
			NULL, LOAD_WITH_ALTERED_SEARCH_PATH);

		if (hInstC == NULL) {
			err = GetLastError();
			mexPrintf("load fail %d\n", err);
			plhs[0] = mxCreateDoubleScalar(0);
			FreeLibrary(hInstC);
			return;
		}
		else{
			mexPrintf("load success!  \n");
			plhs[0] = mxCreateDoubleScalar(1);
			// FreeLibrary(hInstC);
			// return;
		}

		startFun = (FunDLL1)GetProcAddress(hInstC, "dllStart");
		setFun = (FunDLL2)GetProcAddress(hInstC, "dllSetValue");
		advanceFun = (FunDLL3)GetProcAddress(hInstC, "dllAdvance");
		endFun = (FunDLL4)GetProcAddress(hInstC, "dllEnd");

		token = startFun("ZtOE0Jfu_insA.xml",
                initTool, setToTool, setFinish, endTool);

		plhs[0] = mxCreateDoubleScalar(1);
        
        stepNumber = 1;
        
		return;
	}
    
    if(stepNumber == 1) {
        mexPrintf("initTool begin \n");
        double startTime = mxGetScalar(prhs[0]);
        // double startTime =0;
        double step = mxGetScalar(prhs[1]);
        // double step = 0.1;
        initTool(startTime,step);
        stepNumber = 2;
        mexPrintf("initTool end \n");
        plhs[0] = mxCreateDoubleScalar(2);
        return;
    }
    
    double choose = mxGetScalar(prhs[1]);
    if(stepNumber == 2 && choose == 1){
        
        // double time;
        double time = mxGetScalar(prhs[0]);
        // char *name;
        char *buf;
        size_t buflen;
        int status;
        buflen = mxGetN(prhs[2])+1;
        buf = (char *)mxMalloc(buflen);
        status = mxGetString(prhs[2], buf, (mwSize)buflen);
        mexPrintf("%s \n",buf);
        char *name = buf;
        // void *data;
        double tmp = mxGetScalar(prhs[0]);
        void *data = (void *)(&tmp);
        setToTool(time,name,data);
        
        plhs[0] = mxCreateDoubleScalar(2);
        return;
    }
    
    if(stepNumber == 2 && choose == 2) {
        stepNumber = 3;
        // double time;
        double time = mxGetScalar(prhs[0]);
        setFinish(time);
        
        plhs[0] = mxCreateDoubleScalar(2);
        return;
    }
    
    if(stepNumber == 3){
        endTool();
        return;
    }
    
// 		while (1) {
// 			Sleep(30);
// 			if (endFlag == 1) {
// 				FreeLibrary(hInstC);
// 				break;
// 			}
// 		}

	// avoid exe exits
	// getchar();
	plhs[0] = mxCreateDoubleScalar(2);
	return;
}
