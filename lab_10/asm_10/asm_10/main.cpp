#include <iostream>
using namespace std;
#include "asm_scalar.h"
#include "default_scalar.h"
#include <time.h>
#define TIMES 1000000
void get_time(float *a, float *b, float *cc, int n, int n_help)
{
	clock_t begin = clock();
	for (int i = 0; i < TIMES; i++)
	{
		float* pa = a;
		float* pb = b;
		float* pc = cc;
		default_scalar(a, b, n);
	}
	clock_t end = clock();
	cout << "\tc++ scalar mult time " << ((double)(end - begin) / CLOCKS_PER_SEC / TIMES) << endl;
	begin = clock();
	for (int i = 0; i < TIMES; i++)
	{
		float* pa = a;
		float* pb = b;
		float* pc = cc;
		asm_scalar(pa, pb, pc, n_help);
	}
	end = clock();
	cout << "\tasm scalar mult time " << ((double)(end - begin) / CLOCKS_PER_SEC / TIMES) << endl;
}
int main()
{
	int n;
	cout << "INPUT N:" << endl;
	cin >> n;
	int n_help = n;
	while (n_help % 4 != 0)
		n_help++;

	float* a;
	float* b;
	float* c;
	a = new float[n];
	b = new float[n];
	c =  (float *)calloc (n, sizeof (float));
	cout << "Vect1:" << endl;
	for (int i = 0; i < n; i++)
		cin>> a[i];
	cout << "Vect2:" << endl;
	for (int i = 0; i < n; i++)
		cin >> b[i];


	cout << "n help" << n_help << endl;
	n_help /= 4;
	float* cc = c;
	float* bc = a;
	float* ac = b;

	float ans = default_scalar(a, b, n);
	cout << ans << endl;
	ans = asm_scalar(ac, bc, cc, n_help);
	cout << ans << endl;
	get_time(a, b, c, n, n_help);
	

	
	
	return 0;
}