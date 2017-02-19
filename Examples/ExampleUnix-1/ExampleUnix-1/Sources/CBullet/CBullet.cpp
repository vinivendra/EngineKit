#import "include/CBullet.h"
#include <iostream>
#include <btBulletDynamicsCommon.h>

btBroadphaseInterface* broadphase;
btDefaultCollisionConfiguration* collisionConfiguration;
btCollisionDispatcher* dispatcher;
btSequentialImpulseConstraintSolver* solver;
btDiscreteDynamicsWorld* dynamicsWorld;

btCollisionShape* groundShape;
btRigidBody* groundRigidBody;

void cBulletInit() {
	// Init bullet
	broadphase = new btDbvtBroadphase();
	collisionConfiguration = new btDefaultCollisionConfiguration();
	dispatcher = new btCollisionDispatcher(collisionConfiguration);
	solver = new btSequentialImpulseConstraintSolver;
	dynamicsWorld = new btDiscreteDynamicsWorld(dispatcher,
												broadphase,
												solver,
												collisionConfiguration);

	dynamicsWorld->setGravity(btVector3(0, -10, 0));

	// Create ground shape
	groundShape = new btStaticPlaneShape(btVector3(0, 1, 0), 1);
	btDefaultMotionState* groundMotionState =
		new btDefaultMotionState(btTransform(btQuaternion(0, 0, 0, 1),
											 btVector3(0, -4, 0)));
	btRigidBody::btRigidBodyConstructionInfo
	groundRigidBodyCI(0,
					  groundMotionState,
					  groundShape,
					  btVector3(0, 0, 0));
	groundRigidBody = new btRigidBody(groundRigidBodyCI);
	dynamicsWorld->addRigidBody(groundRigidBody);
}

void cBulletStep(double deltaTime) {
	dynamicsWorld->stepSimulation(deltaTime, 10);
}

void cBulletGetTransform(CPhysicsBody physicsBody,
						 double *px, double *py, double *pz,
						 double *rx, double *ry, double *rz, double *rw) {
	btRigidBody *rigidBody = (btRigidBody *)physicsBody.body;
	btTransform trans;

	rigidBody->getMotionState()->getWorldTransform(trans);
	btVector3 position = trans.getOrigin();
	btQuaternion rotation = trans.getRotation();
	*px = position.getX();
	*py = position.getY();
	*pz = position.getZ();

	*rx = rotation.getX();
	*ry = rotation.getY();
	*rz = rotation.getZ();
	*rw = rotation.getW();
}

CPhysicsBody cBulletCreateBody(double px, double py, double pz,
							   double rx, double ry, double rz, double rw) {
	btVector3 halfBoxSize = btVector3(1, 1, 1);
	btCollisionShape *shape = new btBoxShape(halfBoxSize);
	btDefaultMotionState *motionState =
		new btDefaultMotionState(btTransform(btQuaternion(rx, ry, rz, rw),
											 btVector3(px, py, pz)));
	btScalar mass = 1;
	btVector3 inertia(0, 0, 0);
	shape->calculateLocalInertia(mass, inertia);
	btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(mass,
														 motionState,
														 shape,
														 inertia);
	btRigidBody *rigidBody = new btRigidBody(rigidBodyCI);
	dynamicsWorld->addRigidBody(rigidBody);

	CPhysicsBody physicsBody;
	physicsBody.body = rigidBody;
	physicsBody.shape = shape;

	return physicsBody;
}

void cBulletDestroyObject(CPhysicsBody physicsBody) {
	btRigidBody *body = (btRigidBody *)physicsBody.body;
	btCollisionShape *shape = (btCollisionShape *)physicsBody.shape;
	dynamicsWorld->removeRigidBody(body);
	delete body->getMotionState();
	delete body;

	delete shape;
}

void cBulletDestroy() {
	dynamicsWorld->removeRigidBody(groundRigidBody);
	delete groundRigidBody->getMotionState();
	delete groundRigidBody;
	
	delete groundShape;

	delete dynamicsWorld;
	delete solver;
	delete collisionConfiguration;
	delete dispatcher;
	delete broadphase;
}
