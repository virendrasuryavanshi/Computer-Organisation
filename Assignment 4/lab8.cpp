#include <iostream> 
#include <stdio.h>
#include <string.h>

using namespace std; 

class Cache2Way
{
private:
  unsigned int size; // in bytes
  unsigned int blocks;
  int replacement;

  typedef struct mem{
    unsigned int tag;
    bool valid;
    unsigned int timestamp;
  }memory;

  unsigned int times;
  memory *M;
public:
  Cache2Way(unsigned int SIZE,int r)
  {
    size=SIZE;
    replacement=r;

    times ++;
    blocks = size>>4;
    cout<<"Size of cache in blocks : "<<blocks<<endl;
    M = new memory[blocks];
    for (int i = 0; i < blocks; ++i)
    {
      M[i].valid=false; M[i].timestamp=0;
    }
  }

  void time_rearrangement(unsigned int tag, unsigned int set_index, unsigned int subindex, bool hit)
  {
    if (hit)
    {
      if (replacement==0)
        (M+(2*set_index + subindex))->timestamp = times;
    }
    else
    {
      if ((M+(2*set_index))->timestamp < (M+(2*set_index+1))->timestamp )
        subindex=0;
      else
        subindex=1;
      (M+(2*set_index + subindex))->tag = tag;
      (M+(2*set_index + subindex))->timestamp = times;
      (M+(2*set_index + subindex))->valid = true;
    }
  }

  bool access(unsigned int address)
  {
    times++;
    unsigned int s = address>>4;
    unsigned int set_index = s&((blocks>>1)-1);
    unsigned int subindex = 0;
    bool hit=false;

    for (int i=0;i<2;++i)
    {
      if ((M+(2*set_index+i))->tag==s && (M+(2*set_index+i))->valid)
      {
        hit=true;
        subindex=i;
        break;
      }
    }

    time_rearrangement(s,set_index,subindex,hit);
    return hit;
  }
};

class CacheDirect
{
private:
  unsigned int size; //in bytes
  unsigned int blocks;
  typedef struct mem
  {
    unsigned int tag;
    bool valid;
  }memory;
  memory* M;
public:
  CacheDirect(unsigned int SIZE)
  {
    size=SIZE;
    blocks=size>>4;
    cout<<"Size of cache in blocks : "<<blocks<<endl;
    M = new memory[blocks];
    for(int i=0; i<blocks ;++i)
    {
      M[i].valid=false;
    }
  }

  bool access(unsigned int address)
  {
    unsigned int s=address>>4;
    unsigned int index = s&(blocks-1);
    // index = s%(blocks);
    // cout<<index<<endl;
    bool hit;
    if ((M+index)->tag==s && (M+index)->valid)
      hit=true;
    else
      hit=false;
    (M+index)->tag=s;
    (M+index)->valid=true;
    return hit;
  }
};

int main(int argc, char const *argv[])
{
	unsigned int nl=0;
	FILE* f=fopen(argv[1],"r");
	char ch;
	while (EOF != (ch=getc(f)))
		if (ch=='\n')
		  ++nl;
  fseek(f,0,SEEK_SET );

  CacheDirect c1[5] = {CacheDirect(1024),CacheDirect(2048),CacheDirect(4096),CacheDirect(8192),CacheDirect(16384)};
  Cache2Way c2[5] = {Cache2Way(1024,0),Cache2Way(2048,0),Cache2Way(4096,0),Cache2Way(8192,0),Cache2Way(16384,0)};
  Cache2Way c3[5] = {Cache2Way(1024,1),Cache2Way(2048,1),Cache2Way(4096,1),Cache2Way(8192,1),Cache2Way(16384,1)};

  int **hits=new int*[3];
  for (int i=0;i<3;++i) {
    hits[i]=new int[5];
    for (int j=0;j<5;++j)
      hits[i][j]=0;
  }

  int **miss=new int*[3];
  for (int i=0;i<3;++i) {
    miss[i]=new int[5];
    for (int j=0;j<5;++j)
      miss[i][j]=0;
  }

  cout<<"#"<<endl;
  unsigned int input;
  for (int i=0;i<nl;++i)
  {
    fscanf(f,"%X",&input);
    for (int j=0;j<5;++j)
    {
      if (c1[j].access(input))
        hits[0][j]++;
      else
        miss[0][j]++;
      if (c2[j].access(input))
        hits[1][j]++;
      else
        miss[1][j]++;
      if (c3[j].access(input))
        hits[2][j]++;
      else
        miss[2][j]++;
      // cout<<"@"<<endl;
    }
  }

  fclose(f);
  char outfile[100];
  strcpy(outfile,argv[1]);
  strcat(outfile,".csv");
  f=fopen(outfile,"w");
  fprintf(f, "bytes/method,1024,2048,4096,8192,16384\n" );
  fprintf(f, "Direct" );
  for (int i=0;i<5;++i)
    fprintf(f, ",%e",((hits[0][i]*1.0) - 1));
  fprintf(f, "\n2-Way_FIFO");
  for (int i=0;i<5;++i)
    fprintf(f, ",%e",((hits[2][i]*1.0) - 1));
  fprintf(f, "\n2-Way_LRU");
  for (int i=0;i<5;++i)
    fprintf(f, ",%e",((hits[1][i]*1.0) - 1));
  fprintf(f, "\n" );


  strcpy(outfile,argv[2]);
  strcat(outfile,".csv");
  f=fopen(outfile,"w");
  fprintf(f, "bytes/method,1024,2048,4096,8192,16384\n" );
  fprintf(f, "Direct" );
  for (int i=0;i<5;++i)
    fprintf(f, ",%e",((miss[0][i]*1.0) - 1 / (hits[0][i]*1.0 - 1 + miss[0][i]*1.0 - 1)));
  fprintf(f, "\n2-Way_FIFO");
  for (int i=0;i<5;++i)
    fprintf(f, ",%e",(miss[2][i]*1.0) - 1 / (hits[2][i]*1.0 - 1 + miss[2][i]*1.0 - 1));
  fprintf(f, "\n2-Way_LRU");
  for (int i=0;i<5;++i)
    fprintf(f, ",%e",((hits[1][i]*1.0) - 1 / (hits[1][i]*1.0 - 1 + miss[1][i]*1.0 - 1)));
  fprintf(f, "\n" );

  fclose(f);
  return 0;
}
