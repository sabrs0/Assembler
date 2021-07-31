float default_scalar(float* a, float* b, int n)
{
	float ans = 0;
	float mul;
	for (int i = 0; i < n; i++)
	{
		mul = a[i] * b[i];
		ans += mul;
	}
	return ans;
}