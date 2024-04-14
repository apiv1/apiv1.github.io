#include <windows.h>
#include <stdio.h>

void *myGetProcAddress(HMODULE hModule, const char *function_name)
{
  if (hModule == NULL || function_name == NULL)
    return NULL;

  PIMAGE_DOS_HEADER pImageDosHeader = (PIMAGE_DOS_HEADER)hModule;
  PIMAGE_NT_HEADERS pImageNtHeader = (PIMAGE_NT_HEADERS)((BYTE *)hModule + pImageDosHeader->e_lfanew);
  PIMAGE_OPTIONAL_HEADER pImageOptionalHeader = &pImageNtHeader->OptionalHeader;
  PIMAGE_EXPORT_DIRECTORY pImageExportDirectory = (PIMAGE_EXPORT_DIRECTORY)((BYTE *)hModule + pImageOptionalHeader->DataDirectory[0].VirtualAddress);
  {
    DWORD *nameList = (DWORD *)((BYTE *)hModule + pImageExportDirectory->AddressOfNames);
    WORD *nameOrdinalList = (WORD *)((BYTE *)hModule + pImageExportDirectory->AddressOfNameOrdinals);
    DWORD *functionList = (DWORD *)((BYTE *)hModule + pImageExportDirectory->AddressOfFunctions);

    for (int i = 0; i < pImageExportDirectory->NumberOfNames; ++i)
    {
      const char *dest_function_name = (BYTE *)hModule + nameList[i];
      void *func = (BYTE *)hModule + functionList[nameOrdinalList[i]];
      if (strcmp(dest_function_name, function_name) == 0)
      {
        return func;
      }
    }
  }
  return NULL;
}

int main()
{
  HMODULE hModule = NULL;
  hModule = LoadLibrary("ws2_32.dll");
  printf("Dll: %p\n", hModule);

  void *func = GetProcAddress(hModule, "socket");
  printf("GetProcAddress: %p\n", func);
  func = myGetProcAddress(hModule, "socket");
  printf("myGetProcAddress: %p\n", func);

  return 0;
}
