//var ball1 = new EKSphere();
//ball1.radius = 5;
//ball1.physics = "dynamic"
//
//var ball2 = new EKSphere();
//ball2.radius = 2;
//ball2.position = [-10, 0, 0];
//ball2.color = "green"
//ball2.physics = "static"

var ball = new EKSphere();
ball.color = "purple";
ball.physics = "dynamic";
ball.position = [Math.random() * 10 - 5, 2, 4];

var ball2 = new EKSphere();
ball2.color = "blue";
ball2.physics = "dynamic";
ball2.position = [-5, -2, 4];
ball2.velocity = [3 + Math.random() * 3,
				 3 + Math.random() * 3,
				 0];
