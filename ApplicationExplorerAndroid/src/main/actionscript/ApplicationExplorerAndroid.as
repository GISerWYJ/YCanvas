package
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Rectangle;
    
    import net.hires.debug.Stats;
    
    import sk.yoz.ycanvas.demo.explorer.events.ModeEvent;
    import sk.yoz.ycanvas.demo.explorer.managers.CanvasManager;
    import sk.yoz.ycanvas.demo.explorer.managers.MobileTransformationManager;
    import sk.yoz.ycanvas.demo.explorer.modes.Mode;
    import sk.yoz.ycanvas.demo.explorer.view.Board;
    import sk.yoz.ycanvas.demo.explorer.view.Buttons;
    
    [SWF(frameRate="60", backgroundColor="#ffffff")]
    public class ApplicationExplorerAndroid extends Sprite
    {
        private var board:Board = new Board;
        
        private var canvasManager:CanvasManager;
        private var transformationManager:MobileTransformationManager;
        private var buttons:Buttons;
        
        public function ApplicationExplorerAndroid()
        {
            stage ? init() : addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(... rest):void
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            if(loaderInfo.parameters.debug == "true")
                addChild(new Stats);
            
            board.doubleClickEnabled = true;
            
            canvasManager = new CanvasManager(stage, stage.stage3Ds[0], viewPort, 
                canvasInit, this);
            
            buttons = new Buttons;
            buttons.addEventListener(ModeEvent.CHANGE, onModeChange);
            
            stage.addEventListener(Event.RESIZE, onStageResize);
            updateViewPort();
        }
        
        private function canvasInit():void
        {
            transformationManager = new MobileTransformationManager(canvasManager.canvas, board, this);
            transformationManager.limits = Mode.ONBOARD.limits;
            canvasManager.mode = Mode.ONBOARD;
            
            addChild(board);
            addChild(buttons);
        }
        
        private function get viewPort():Rectangle
        {
            var left:uint = 0;
            var right:uint = 0;
            var top:uint = 0;
            var bottom:uint = 0;
            var width:uint = stage.stageWidth;
            var height:uint = stage.stageHeight;
            return new Rectangle(left, top, width - left - right, height - top - bottom);
        }
        
        private function updateViewPort():void
        {
            canvasManager.viewPort = viewPort;
            board.viewPort = viewPort;
            buttons.x = 10;
            buttons.y = viewPort.top + viewPort.height - buttons.height - 10;;
        }
        
        private function onStageResize(event:Event):void
        {
            updateViewPort();
        }
        
        private function onModeChange(event:ModeEvent):void
        {
            canvasManager.mode = event.mode;
            transformationManager.limits = event.mode.limits;
        }
    }
}