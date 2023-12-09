#include <stdio.h>
#define N 9
#define N_BOX 3

int mat[N][N] = {0};

int mat_set[N][N] = {0};

int g_judge_count = 0;

int Judge(int x, int y)
{
    ++g_judge_count;
    //Line & Cols
    //if(0)
    {
        int i;
        int s = mat[y][x];
        for(i=0; i < N ; ++i)
        {
            if( (i!=x && s==mat[y][i])
                    ||  (i!=y && s==mat[i][x]) )
            {
                //printf("y=%d,x=%d\n",y,x);
                return 0;
            }
        }
    }
    //Box
    //if(0)
    {
        int x_start = x / N_BOX * N_BOX;
        int x_stop = x_start + N_BOX;
        int y_start = y / N_BOX * N_BOX;
        int y_stop = y_start + N_BOX;
        int ix,iy;
        for(iy=y_start; iy < y_stop; ++iy)
        {
            for(ix=x_start; ix < x_stop; ++ix)
            {
                //printf("ix=%d,iy=%d\n",ix,iy);
                if(  (ix!=x && iy!=y)
                        &&  mat[iy][ix]==mat[y][x]
                  )
                {
                    return 0;
                }
            }
        }
    }
    return 1;
}

int Input()
{
    int ix,iy;
    for(iy=0; iy < N; ++iy)
    {
        for(ix=0; ix < N; ++ix)
        {
            int s;
            fscanf(stdin,"%d",&s);
            mat[iy][ix] = mat_set[iy][ix] = s;
        }
    }
    return 0;
}

int Output()
{
    int ix,iy;
    for(iy=0; iy < N; ++iy)
    {
        for(ix=0; ix < N; ++ix)
        {
            printf("%d ",mat[iy][ix]);
            if( (ix+1)%3==0 )putchar(' ');
        }
        printf("\n");
        if( (iy+1)%3==0 )putchar('\n');
    }
    return 0;
}

int Check()
{
    int i=0;
    g_judge_count = 0;
    while(0<=i && i<N*N)
    {
        //printf("%d\n",i);
        if(mat_set[i/N][i%N]!=0)//Is Set
        {
            ++i;
            continue;
        }
        for( ++mat[i/N][i%N]; mat[i/N][i%N]<=N; ++mat[i/N][i%N])
        {
            if(Judge(i%N,i/N))
            {
                break;
            }
        }
        if(mat[i/N][i%N]>N) //Not Found
        {
            mat[i/N][i%N] = 0;
            --i;
            while(0<=i && mat_set[i/N][i%N]!=0)--i;
        }
        else
        {
            ++i;
        }
    }
    if(i==N*N)
        return 1;
    return 0;
}

int main()
{
    Input();
    if(Check())
    {
        Output();
        printf("Judge Count = %d\n",g_judge_count);
    }
    else
    {
        printf("Not Found\n");
    }
    return 0;
}


