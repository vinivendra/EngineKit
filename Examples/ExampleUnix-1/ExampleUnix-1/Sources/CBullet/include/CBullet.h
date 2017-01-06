#ifdef __cplusplus
extern "C"  {
#endif

	void cBulletInit();
	void cBulletStep(double deltaTime);
	double cBulletGetHeight();
	void cBulletDestroy();

#ifdef __cplusplus
}
#endif
