#include <stdio.h>
#include <windows.h>

int main(int argc, char** argv)
{
   if(argc<3)
    {
       fprintf(stdout,"\nUsage : %s <pid> <dll-path>\n\n",argv[0]);
       return 1;
    }

    DWORD Pid,DllPathLen;
   if(sscanf(argv[1],"%u",&Pid)<=0 ) // Get Process Id
    {
       fprintf(stderr,"\n[-] ERROR: Pid Value\n"),fflush(stderr);
       return 1;
    }
    if(  DllPathLen = strlen(argv[2]),DllPathLen == 0 ) // Get Dll Path
    {
       fprintf(stderr,"\n[-] ERROR: DllPath\n"),fflush(stderr);
       return 1;
    }

    // Get Process Handle
    HANDLE hDstProc = OpenProcess(PROCESS_CREATE_THREAD|PROCESS_VM_OPERATION|PROCESS_VM_WRITE,TRUE,Pid);
   if(hDstProc==NULL)
    {
       fprintf(stderr,"\n[-] ERROR: in OpenProcess(), Pid %u\n",Pid),fflush(stderr);
       return 1;
    }

    // Get LoadLibraryA Address
   fprintf(stdout,"\n[+] Pid: %u, Handle : 0Xx \n",Pid,hDstProc),fflush(stdout);
   LPTHREAD_START_ROUTINE LibFunc =
      (LPTHREAD_START_ROUTINE)GetProcAddress(GetModuleHandle("Kernel32"),"LoadLibraryA");
   fprintf(stdout,"\n[+] LoadLibraryA Address : 0Xx\n",LibFunc),fflush(stdout);

    // Create Remote Heap, Set Dll Path
    DWORD Success = TRUE;
    char * DllPath = (char*) VirtualAllocEx(hDstProc,NULL,DllPathLen + 1,MEM_COMMIT,PAGE_READWRITE);
   if(DllPath)
    {
fprintf(stdout,"\n[+] Create Memory in %u, Address : 0Xx\n",Pid,DllPath);
      if(WriteProcessMemory(hDstProc,DllPath,argv[2],DllPathLen + 1,NULL))
       {
          fprintf(stdout,"\n[+] Set Dll Path : %s\n",argv[2]);
       }
       else
       {
          fprintf(stderr,"\n[-] ERROR: in WriteProcessMemory(), Set Dll Path Failed\n");
          Success = FALSE;
       }
    }
   else
    {
       fprintf(stderr,"\n[-] ERROR: in VirtualAllocEx(), Get Memory\n");
       Success = FALSE;
    }

    //Start Dll Inject
   if(Success)
    {
       HANDLE hThread = CreateRemoteThread(hDstProc,NULL,0,LibFunc,DllPath,0,NULL);
       if(hThread)
       {
          fprintf(stdout,"\n[+] Create Remote Thread, Handle : 0Xx, Dll Injection Success\n",hThread);
       }
       else
       {
          fprintf(stderr,"\n[-] in CreateRemoteThread(), Dll Injection Failed\n");
          Success = FALSE;
       }
       CloseHandle(hThread);
    }

   //Cleaning
   VirtualFreeEx(hDstProc,DllPath,0,MEM_RELEASE);
   CloseHandle(hDstProc);

    return !Success;
}
