#include <stdio.h>

static char *number[] = {
  "零","一","二","三","四","五","六","七","八","九"
};

static char *unit(int n)
{
  static char* unitList[] = {
    "十", "百", "千", "万", "十", "百", "千", "亿"
  };
  if(n<=0) return "";
  return unitList[ (n-1)%8 ];
}

void printHanzi(const char* buf)
{
  if(buf == NULL) return;
  if(*buf=='-')
  {
    printf("负");
    ++buf;
  }
  while(*buf == '0') ++buf; //去除头0
  int length = 0;
  while('0'<=buf[length] && buf[length]<='9') ++length;
  if(length == 0)
  {
    printf("%s",number[0]);
    return;
  }
  int i = 0;
  int zeroflag = -1, wanflag = 0;
  while(i<length)
  {
    int weight = length - 1 - i; //当前位置, 个位为0
    int c = buf[i] - '0';       //当前位的数
    if(c == 0)
    {
      if(!zeroflag) //处理 '0' 位
      {
        wanflag = ( (weight+1) %8 != 0); //设置 单位 '万' 的输出: 若当前位的上一位不是 '亿', 则输出接下来遇到的第一个 万
      }
      if(wanflag == 1 && (weight % 8 == 4)) // 若为万位 并符合输出条件, 输出 单位, 并设置标志位,不再输出'万'
      {
        printf("%s",unit(weight));
        wanflag = 0;
      }
      if(weight %8 == 0) //若为 亿 位, 输出 单位, 并设置标志位 不再输出 '万'
      {
        printf("%s",unit(weight));
        wanflag = 0;
      }
      zeroflag = 1;
    }
    else
    {
      if(zeroflag == 1) //输出 '零'
      {
        printf("%s",number[0]);
      }
      if(!( i == 0 && c == 1 && length%4 == 2 ) ) //判断是否以 十 开头 (十, 十万, 十亿, 不输出 '一')
      {
        if( c == 2 &&  weight % 4 != 1 && zeroflag != 0) // 判断是否 是 十, 十万, 十亿 不能输出 '两'
          printf("%s", "两");
        else
          printf("%s",number[c]);
      }
      printf("%s",unit(weight));
      zeroflag =  0;
    }
    ++i;
  }
}