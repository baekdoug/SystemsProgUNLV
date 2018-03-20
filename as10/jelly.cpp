// ----------------------------------------------------------------------
//  CS 218, Assignment #10
//  Provided main

#include <cstdlib>
#include <iostream>
#include <string>
#include <cmath>

#include <stdio.h>
#include <math.h>
#include <GL/gl.h>
#include <GL/glut.h>
#include <GL/freeglut.h>

using	namespace	std;

// ----------------------------------------------------------------------
//  External functions (in seperate file).

extern "C" int getArguments(int, char* [], int *, int *, int *, int *, int *);
extern "C" void drawJellyfish();


// ----------------------------------------------------------------------
//  Global variables
//	Must be globally accessible for the openGL
//	display routine.

double	viewAngle = 45.0;			// default view angle
double	tipAngle = 0.0;
int	drawSpeed = 0;
int	pointSize = 0;
int	color = 0;

// ----------------------------------------------------------------------
//  Key handler function.
//	Check for exits keys ('x', 'q', or ESC).

void	keyHandler(unsigned char key, int x, int y)
{
	if (key == 'x' || key == 'q' || key == 27) {
		glutLeaveMainLoop();
		exit(0);
	}
}

// ----------------------------------------------------------------------
//  Key handler function (arrow keys).
//	Updates viewing angles for rotation based on arrow keys.

void	arrowHandler(int key, int x, int y)
{
	double	aStep = 5.0;

	if (key == GLUT_KEY_LEFT)
		tipAngle += aStep;

	if (key == GLUT_KEY_RIGHT)
		tipAngle -= aStep;

	if (key == GLUT_KEY_UP)
		viewAngle -= aStep;

	if (key == GLUT_KEY_DOWN)
		viewAngle += aStep;

	glutPostRedisplay();
}

// ----------------------------------------------------------------------
//  Main
//	check command line arguments
//	perform opneGL initializations
//	kickoff openGL main display loop

int main(int argc, char** argv)
{
	int	height = 0, width = 0;
	bool	paramsOK = false;
	float	screenRatio = 0.0;


	// -----
	//  Get and error check the command line arguments.

	paramsOK = getArguments(argc, argv, &height, &width,
				&drawSpeed, &pointSize, &color);


	// -----
	//  If arguments are OK, verify screen ratio.

	if (paramsOK) {
		screenRatio = static_cast<float>(height) /
				static_cast<float>(width);
		if (screenRatio < 0.8 || screenRatio > 1.2) {
			cout << "Error, invalid height/width ratio." << endl;
			paramsOK = false;
		}
	}


	// -----
	// Debug call for display function
	//	drawJellyfish();


	// -----
	//  If arguments are OK, plot the functions...

	if (paramsOK) {
		glutInit(&argc, argv);
		glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
		glutInitWindowSize(height,width);
		glutInitWindowPosition(100,100);

		glutCreateWindow("CS 218 - Assignment #10 Moving Jellyfish");
		glClearColor(0.0, 0.0, 0.0, 0.0);
		glViewport(0, 0, height, width);
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glOrtho(-2.0, 2.0, -2.0, 2.0, 2.0, -2.0);

		glutSpecialFunc(arrowHandler);
		glutKeyboardFunc(keyHandler);
		glutDisplayFunc(drawJellyfish);
	
		glutMainLoop();
	}

	return 0;
}

