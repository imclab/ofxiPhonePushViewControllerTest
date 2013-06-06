#include "testApp.h"

static dispatch_once_t onceToken;

//--------------------------------------------------------------
void testApp::setup(){
    ofxAccelerometer.setup();
    
    ofRegisterTouchEvents(this);

    ofxiPhoneAlerts.addListener(this);
    
    //ofxiPhoneGetOFWindow()->enableRetina();
    
	ofBackground(255,255,255);
    
    camera.setupPerspective();
    camera.setFarClip(8000);
    
    camera.setPosition(ofVec3f( 0, 0, 1000));
    
    for (int i = 0; i< 1000; i++) {
        Node newNode = Node();
        newNode.position = ofVec3f( ofRandom(1000) - 500, ofRandom(1000) - 500, ofRandom(1000) - 500 );
        nodes.push_back( newNode);
    }
}

//--------------------------------------------------------------
void testApp::update(){

    if ([ofxiPhoneGetViewController().glView isAnimating]) {
        
        counter = counter + 0.25f;
    
        camera.lookAt(ofVec3f(0, 0, 0));
    }
}

//--------------------------------------------------------------
void testApp::draw(){
    
    dispatch_once(&onceToken, ^{
        UIWindow * window = ofxiPhoneGetUIWindow();
        
        UIViewController *firstViewController = ofxiPhoneGetViewController();

        firstViewController.title = @"First View Controller";
        
        window.rootViewController = subViewController; // 一時的にrootViewControllerを割り当てないとこける
        
        navigationController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
        
        window.rootViewController = navigationController;
        
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC);
        dispatch_after(delay, dispatch_get_main_queue(), ^{
            [[(ofxiPhoneViewController*)firstViewController glView] startAnimation]; // GLViewがstopしてしまうのでstartを少し遅れて呼ぶ
        });
        
    });
    
    if ([ofxiPhoneGetViewController().glView isAnimating]) {


        camera.begin();
        
        ofRotateY(counter);
        
        ofSetColor(0, 255, 250);
        
        for (int i = 0; i< nodes.size(); i++ ) {
            nodes[i].draw();
        }
        
        camera.end();
        
        ofSetColor(0, 0, 0);
        ofDrawBitmapString("This is ofxiPhoneGLView.. \nTouch and Push viewController", 10, ofGetHeight() / 2 - 50 );
        
    }
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    
    /*
    touch window to push viewController..
    */
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    subViewController = [storyboard instantiateViewControllerWithIdentifier:@"Second-View-Controller"];
    
    [navigationController pushViewController:subViewController animated:YES];
    
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

