#ifdef __cplusplus
extern "C"  {
#endif


typedef struct CPhysicsBody {
	void *body;
	void *shape;
} CPhysicsBody;


//
void cBulletInit();
CPhysicsBody cBulletCreateBody(double px, double py, double pz,
							   double rx, double ry, double rz,
							   double rw);

//
void cBulletStep(double deltaTime);
void cBulletGetTransform(CPhysicsBody physicsBody,
						 double *px, double *py, double *pz,
						 double *rx, double *ry, double *rz, double *rw);

//
void cBulletDestroyObject(CPhysicsBody physicsBody);
void cBulletDestroy();


#ifdef __cplusplus
}
#endif
