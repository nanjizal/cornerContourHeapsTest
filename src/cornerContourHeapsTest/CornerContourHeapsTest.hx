package cornerContourHeapsTest;

// contour code
import cornerContour.Sketcher;
import cornerContour.Pen2D;
import cornerContour.StyleSketch;
import cornerContour.StyleEndLine;
// SVG path parser
import justPath.*;
import justPath.transform.ScaleContext;
import justPath.transform.ScaleTranslateContext;
import justPath.transform.TranslationContext;

import h2d.Graphics;

function main(){
    new CornerContourHeapsTest();
}

class CornerContourHeapsTest extends hxd.App {
    // cornerContour specific code
    var sketcher:       Sketcher;
    var pen2D:          Pen2D;
    
    var quadtest_d      = "M200,300 Q400,50 600,300 T1000,300";
    var cubictest_d     = "M100,200 C100,100 250,100 250,200S400,300 400,200";
    
    // normal heaps
    public var width:  Int;
    public var height: Int;
    var g:    h2d.Graphics; 
    
    override
    function init() {
        engine.backgroundColor = 0xFF000000;
        g       = new h2d.Graphics( s2d );
        width   = s2d.width;
        height  = s2d.height;
        pen2D = new Pen2D( 0x0000FF );
        g.clear();
        arcSVG();
        pen2D.currentColor = 0xff0000FF;
        birdSVG();
        cubicSVG();
        quadSVG();
        drawHeaps();
        pen2D.applyFill( triangle2DFill );
    }
    public function triangle2DFill( ax: Float, ay: Float
                                  , bx: Float, by: Float
                                  , cx: Float, cy: Float
                                  , ?color: Int ){
        
        // convert color to ARGB
        trace( color );
        var red   = redChannel( color );
        var green = greenChannel( color );
        var blue  = blueChannel( color );
        var alpha = alphaChannel( color );
        var alpha = 1.;
        g.beginFill( 0xffffffff );
        g.addVertex( ax*2, ay*2, red, green, blue, alpha );
        g.addVertex( bx*2, by*2, red, green, blue, alpha );
        g.addVertex( cx*2, cy*2, red, green, blue, alpha );
        g.endFill();
    }
    public static inline
    function alphaChannel( int: Int ) : Float
        return ((int >> 24) & 255) / 255;
    public static inline
    function redChannel( int: Int ) : Float
        return ((int >> 16) & 255) / 255;
    public static inline
    function greenChannel( int: Int ) : Float
        return ((int >> 8) & 255) / 255;
    public static inline
    function blueChannel( int: Int ) : Float
        return (int & 255) / 255;
    // override
    public
    function renderDraw(){
        // draw stuff every frame
    }
    override
    function update( dt: Float ) {
        
    }
    /**
     * draw Heaps word ... not very well
     */
    public function drawHeaps(){
        var sketcher = new Sketcher( pen2D, StyleSketch.Fine, StyleEndLine.no );
        sketcher.width = 5;
        var cols = [ 0xFF9400D3 // violet
                   , 0xFF00ff00 // green
                   , 0xFFFF7F00 // orange
                   , 0xFF4b0082 // indigo
                   ,  0xFFFFFF00 // yellow
                   ];
        // H 
        pen2D.currentColor = cols[0];
        sketcher.moveTo( 36, 45 );
        sketcher.lineTo( 36, 107 );
        sketcher.moveTo( 36, 76 );
        sketcher.lineTo( 83, 76 );
        sketcher.moveTo( 83, 45 );
        sketcher.lineTo( 83, 107 );
        // e
        pen2D.currentColor = cols[1];
        sketcher.moveTo( 98, 84 );
        sketcher.quadThru( 107, 70, 118, 64 );
        sketcher.quadThru( 129, 70, 137, 84 );
        sketcher.lineTo( 98, 84 );
        sketcher.quadThru( 106, 102, 118, 107 );
        sketcher.quadThru( 128, 105, 137, 99 );
        pen2D.currentColor = cols[2];
        // a
        sketcher.moveTo( 148, 72 );
        sketcher.quadThru( 157, 67, 166, 64 );
        sketcher.quadThru( 173, 67, 181, 72 );
        sketcher.lineTo( 181, 103 );
        sketcher.quadThru( 183, 107, 186, 103 );
        sketcher.moveTo( 181, 80 );
        sketcher.quadThru( 173, 82, 166, 85);
        sketcher.quadThru( 155, 90, 148, 101 ); 
        sketcher.lineTo( 149, 103 );
        sketcher.quadThru( 157, 106, 166, 107 );
        sketcher.quadThru( 173, 105, 181, 97 );
        // p
        pen2D.currentColor = cols[3];
        sketcher.moveTo( 200, 80 );
        sketcher.quadThru( 210, 67, 227, 63 );
        sketcher.quadThru( 233, 65, 235, 69 );
        sketcher.quadThru( 233, 100, 218, 107 );
        sketcher.quadThru( 210, 104, 200, 96 );
        sketcher.moveTo( 200, 70 );
        sketcher.lineTo( 200, 126 );
        // s
        pen2D.currentColor = cols[4];
        sketcher.moveTo( 278, 71 );
        sketcher.quadThru( 270, 66, 263, 64 );
        sketcher.quadThru( 254, 66, 248, 73 );
        sketcher.quadThru( 254, 80, 263, 86 );
        sketcher.quadThru( 270, 89, 278, 98 );
        sketcher.quadThru( 270, 104, 263, 107 );
        sketcher.quadThru( 254, 104, 249, 98 );
    }
    /**
     * draws Kiwi svg
     */
    public
    function birdSVG(){
        var sketcher = new Sketcher( pen2D, StyleSketch.Fine, StyleEndLine.both );
        sketcher.width = 2;
        var scaleTranslateContext = new ScaleTranslateContext( sketcher, 20, 0, 1, 1 );
        var p = new SvgPath( scaleTranslateContext );
        p.parse( bird_d );
    }
    /** 
     * draws cubic SVG
     */
    public
    function cubicSVG(){
        var sketcher = new Sketcher( pen2D, StyleSketch.Fine, StyleEndLine.both );
        sketcher.width = 10;
        // function to adjust color of curve along length
        sketcher.colourFunction = function( colour: Int, x: Float, y: Float, x_: Float, y_: Float ):  Int {
            return Math.round( colour-1*x*y );
        }
        var translateContext = new TranslationContext( sketcher, 50, 200 );
        var p = new SvgPath( translateContext );
        p.parse( cubictest_d );
    }
    /**
     * draws quad SVG
     */
    public
    function quadSVG(){
        var sketcher = new Sketcher( pen2D, StyleSketch.Fine, StyleEndLine.both );
        sketcher.width = 1;
        // function to adjust width of curve along length
        sketcher.widthFunction = function( width: Float, x: Float, y: Float, x_: Float, y_: Float ): Float{
            return width+0.008*2;
        }
        var translateContext = new ScaleTranslateContext( sketcher, 0, 100, 0.5, 0.5 );
        var p = new SvgPath( translateContext );
        p.parse( quadtest_d );
    }
    /**
     * draws elipse arcs
     */
    public
    function arcSVG(){
        var arcs0  = [ arc0_0, arc0_1, arc0_2, arc0_3 ];
        var arcs1  = [ arc1_0, arc1_1, arc1_2, arc1_3 ];
        var arcs2  = [ arc2_0, arc2_1, arc2_2, arc2_3 ];
        var arcs3  = [ arc3_0, arc3_1, arc3_2, arc3_3 ];
        var arcs4  = [ arc4_0, arc4_1, arc4_2, arc4_3 ];
        var arcs5  = [ arc5_0, arc5_1, arc5_2, arc5_3 ];
        var arcs6  = [ arc6_0, arc6_1, arc6_2, arc6_3 ];
        var arcs7  = [ arc7_0, arc7_1, arc7_2, arc7_3 ];
        var pallet = [ silver, gainsboro, lightGray, crimson ];
        var x0 = 130;
        var x1 = 450;
        var yPos = [ -30, 100, 250, 400 ];
        var arcs = [ arcs0, arcs1, arcs2, arcs3, arcs4, arcs5, arcs6, arcs7 ];
        for( i in 0...yPos.length ){
            drawSet( arcs.shift(), pallet, x0, yPos[i], 0.5 );
            drawSet( arcs.shift(), pallet, x1, yPos[i], 0.5 );
        }
    }
    // draws a set of svg ellipses.
    function drawSet( arcs: Array<String>, col:Array<Int>, x: Float, y: Float, s: Float ){    
        for( i in 0...arcs.length ) draw_d( arcs[ i ], x, y, s, 1., col[ i ] );
    }
    // draws an svg ellipse
    function draw_d( d: String, x: Float, y: Float, s: Float, w: Float, color: Int ){
        pen2D.currentColor = color;
        var sketcher = new Sketcher( pen2D, StyleSketch.Fine, StyleEndLine.both );
        sketcher.width = w;
        var trans = new ScaleTranslateContext( sketcher, x, y, s, s );
        var p = new SvgPath( trans );
        p.parse( d );
    }
    
    // elipses
    var crimson     = 0xDC143C;
    var silver      = 0xC0C0C0;
    var gainsboro   = 0xDCDCDC;
    var lightGray   = 0xD3D3D3;
    var arc0_0      = "M 100 200 A 100 50 0.0 0 1 250 150";
    var arc0_1      = "M 100 200 A 100 50 0.0 1 0 250 150";
    var arc0_2      = "M 100 200 A 100 50 0.0 1 1 250 150";
    var arc0_3      = "M 100 200 A 100 50 0.0 0 0 250 150";
    var arc1_0      = "M 100 200 A 100 50 0.0 0 0 250 150";
    var arc1_1      = "M 100 200 A 100 50 0.0 1 0 250 150";
    var arc1_2      = "M 100 200 A 100 50 0.0 1 1 250 150";
    var arc1_3      = "M 100 200 A 100 50 0.0 0 1 250 150";
    var arc2_0      = "M 100 200 A 100 50 -15 0 0 250 150";
    var arc2_1      = "M 100 200 A 100 50 -15 0 1 250 150";
    var arc2_2      = "M 100 200 A 100 50 -15 1 1 250 150";
    var arc2_3      = "M 100 200 A 100 50 -15 1 0 250 150";
    var arc3_0      = "M 100 200 A 100 50 -15 0 0 250 150";
    var arc3_1      = "M 100 200 A 100 50 -15 0 1 250 150";
    var arc3_2      = "M 100 200 A 100 50 -15 1 0 250 150";
    var arc3_3      = "M 100 200 A 100 50 -15 1 1 250 150";
    var arc4_0      = "M 100 200 A 100 50 -44 1 0 250 150";
    var arc4_1      = "M 100 200 A 100 50 -44 0 1 250 150";
    var arc4_2      = "M 100 200 A 100 50 -44 1 1 250 150";
    var arc4_3      = "M 100 200 A 100 50 -44 0 0 250 150";
    var arc5_0      = "M 100 200 A 100 50 -44 0 0 250 150";
    var arc5_1      = "M 100 200 A 100 50 -44 1 1 250 150";
    var arc5_2      = "M 100 200 A 100 50 -44 1 0 250 150";
    var arc5_3      = "M 100 200 A 100 50 -44 0 1 250 150";
    var arc6_0      = "M 100 200 A 100 50 -45 0 0 250 150";
    var arc6_1      = "M 100 200 A 100 50 -45 0 1 250 150";
    var arc6_2      = "M 100 200 A 100 50 -45 1 1 250 150";
    var arc6_3      = "M 100 200 A 100 50 -45 1 0 250 150";
    var arc7_0      = "M 100 200 A 100 50 -45 0 0 250 150";
    var arc7_1      = "M 100 200 A 100 50 -45 0 1 250 150";
    var arc7_2      = "M 100 200 A 100 50 -45 1 0 250 150";
    var arc7_3      = "M 100 200 A 100 50 -45 1 1 250 150";
    

    // kiwi bird
    var bird_d = "M210.333,65.331C104.367,66.105-12.349,150.637,1.056,276.449c4.303,40.393,18.533,63.704,52.171,79.03c36.307,16.544,57.022,54.556,50.406,112.954c-9.935,4.88-17.405,11.031-19.132,20.015c7.531-0.17,14.943-0.312,22.59,4.341c20.333,12.375,31.296,27.363,42.979,51.72c1.714,3.572,8.192,2.849,8.312-3.078c0.17-8.467-1.856-17.454-5.226-26.933c-2.955-8.313,3.059-7.985,6.917-6.106c6.399,3.115,16.334,9.43,30.39,13.098c5.392,1.407,5.995-3.877,5.224-6.991c-1.864-7.522-11.009-10.862-24.519-19.229c-4.82-2.984-0.927-9.736,5.168-8.351l20.234,2.415c3.359,0.763,4.555-6.114,0.882-7.875c-14.198-6.804-28.897-10.098-53.864-7.799c-11.617-29.265-29.811-61.617-15.674-81.681c12.639-17.938,31.216-20.74,39.147,43.489c-5.002,3.107-11.215,5.031-11.332,13.024c7.201-2.845,11.207-1.399,14.791,0c17.912,6.998,35.462,21.826,52.982,37.309c3.739,3.303,8.413-1.718,6.991-6.034c-2.138-6.494-8.053-10.659-14.791-20.016c-3.239-4.495,5.03-7.045,10.886-6.876c13.849,0.396,22.886,8.268,35.177,11.218c4.483,1.076,9.741-1.964,6.917-6.917c-3.472-6.085-13.015-9.124-19.18-13.413c-4.357-3.029-3.025-7.132,2.697-6.602c3.905,0.361,8.478,2.271,13.908,1.767c9.946-0.925,7.717-7.169-0.883-9.566c-19.036-5.304-39.891-6.311-61.665-5.225c-43.837-8.358-31.554-84.887,0-90.363c29.571-5.132,62.966-13.339,99.928-32.156c32.668-5.429,64.835-12.446,92.939-33.85c48.106-14.469,111.903,16.113,204.241,149.695c3.926,5.681,15.819,9.94,9.524-6.351c-15.893-41.125-68.176-93.328-92.13-132.085c-24.581-39.774-14.34-61.243-39.957-91.247c-21.326-24.978-47.502-25.803-77.339-17.365c-23.461,6.634-39.234-7.117-52.98-31.273C318.42,87.525,265.838,64.927,210.333,65.331zM445.731,203.01c6.12,0,11.112,4.919,11.112,11.038c0,6.119-4.994,11.111-11.112,11.111s-11.038-4.994-11.038-11.111C434.693,207.929,439.613,203.01,445.731,203.01z";
    
    
}