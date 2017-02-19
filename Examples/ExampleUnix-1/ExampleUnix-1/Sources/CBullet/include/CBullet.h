#ifdef __cplusplus
extern "C"  {
#endif

	typedef struct CPhysicsBody {
		void *body;
		void *shape;
	} CPhysicsBody;

	void cBulletInit();
	void cBulletStep(double deltaTime);
	void cBulletGetTransform(CPhysicsBody physicsBody,
							 double *px, double *py, double *pz,
							 double *rx, double *ry, double *rz, double *rw);
	void cBulletDestroy();
	CPhysicsBody cBulletCreateBody(double px, double py, double pz,
								   double rx, double ry, double rz,
								   double rw);

#ifdef __cplusplus
}
#endif
