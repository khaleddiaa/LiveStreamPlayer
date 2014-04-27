package  
{	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain; 
	import flash.display.Loader;
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	import flash.net.NetStream;
	import flash.net.NetConnection;
	
	public class Player extends EventDispatcher 
	{
		/** variable to access app stage */
		private var _stage:Stage;
		/** Play button should be instance from this class */
		public var PlayButtonClass:Class;
		/** Pause button should be instance from this class */
		public var PauseButtonClass:Class;
		/** FullScreen button should be instance from this class */
		public var FullScreenButtonClass:Class;
		/** Follow button should be instance from this class */
		public var FollowButtonClass:Class;
		/** Opens One way stream channel */
		public var netStreamObj:NetStream;
		/** Create two-ways connection between client and server */
		public var nc:NetConnection;
		/** Stream Id hodler */
		public var streamID:String;
		/** Video URL holder */
		public var videoURL:String;
		/** Listener to trigger when meta data received  */
		public var metaListener:Object;
		/** Object that hold stream meta data*/
		public var metaDara:Object;
		/** loader instance to load swf file */
		private var swfLoader:Loader; 
		/** SWF file url */
		private var swfUrl:String = "../UI/UI.swf";
		/** Captures all request information */
		private var request:URLRequest;
		/** instance from loader class to get assets from swf file */
        private var loaderContext:LoaderContext;		
		/** Current screen state*/
		private var _screenState:String = "normal";
		/**A list of event that should be dispatched */
		public static var ASSETS_LOADED:String = "assetLoaded";
		public static var SCREEN_RESIZED:String = "screenResized";
		public static var META_RECEIVED:String = "metaReceived";
		
		/** Player class constructor*/
		public function Player(stage:Stage,streamid:String,videourl:String) {
			_stage = stage;
			
			streamID = streamid;
			videoURL = videourl;
			
			initPlayer();
		}

		/** Intiate player connections and assets */
		private function initPlayer():void
		{			
			swfLoader = new Loader();
			request = new URLRequest(swfUrl); 
            loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain); 
            swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler); 
			swfLoader.load(request, loaderContext);
						
			nc = new NetConnection();

			nc.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			nc.connect(videoURL);          
		}
		
		/**Tigger SWF file assets completely loaded */
		private function completeHandler(event:Event):void 
        {
            PlayButtonClass = event.target.applicationDomain.getDefinition("PlayButton") as Class;
			PauseButtonClass = event.target.applicationDomain.getDefinition("PauseButton") as Class;	
			FullScreenButtonClass = event.target.applicationDomain.getDefinition("FullScreenButton") as Class;			
			FollowButtonClass = event.target.applicationDomain.getDefinition("FollowButton") as Class;
			
			dispatchEvent(new Event(Player.ASSETS_LOADED));
		}
		
		
		/**Tigger Net Connection status */
		private function onConnectionStatus(e:NetStatusEvent):void
		{
			if (e.info.code == "NetConnection.Connect.Success")
			{
				trace("Creating NetStream");
				netStreamObj = new NetStream(nc);
				metaListener = new Object();
				metaListener.onMetaData = received_Meta;
				netStreamObj.client = metaListener;
				netStreamObj.bufferTime = 5;
				netStreamObj.play(streamID);
			}
		}
		
		/** Meta data received completely with passed data */
		private function received_Meta (data:Object):void
		{
			metaDara = data;
			dispatchEvent(new Event(Player.META_RECEIVED));
		}
		
		/** Screen current state getter function */
		public function get screenState():String
		{
			return _screenState;
		}
		
		/** Screen current state setter function */
		public function set screenState(state:String):void
		{
			_screenState = state;

			if (_stage.displayState == StageDisplayState.NORMAL)
			{
				_stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else
			{
				_stage.displayState = StageDisplayState.NORMAL;
			}
			
			dispatchEvent(new Event(Player.SCREEN_RESIZED));
		}
		
		/**dispatches when an exception is thrown from native asynchronous code */
		public function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			trace("asyncErrorHandler.." + "\r");
		}
	}
	
}
