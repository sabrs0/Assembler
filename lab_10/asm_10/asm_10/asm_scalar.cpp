float asm_scalar(float *a, float* b, float* cc, int n_help)
{
	float ans = 0;
	for (int i = 0; i < n_help; i += 4, a += 4, b += 4, cc += 4)
	{
		_asm {
			mov eax, [a]
			movups xmm1, xmmword ptr[eax];
			mov edx, [b]
				movups xmm2, xmmword ptr[edx];
			mulps xmm1, xmm2;
			movups xmmword ptr[edx], xmm1;
			mov[cc], edx
		}
		ans =  ans + cc[0] + cc[1] + cc[2] + cc[3];
	}
	return ans;
}