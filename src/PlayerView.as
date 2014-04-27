package  
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Video;
	
	public class PlayerView extends Sprite
	{
		/** variable to hold Player instance that passed at constructor */
		private var _player:Player;
		/** Play Button */
		public var play_btn:MovieClip;
		/** Pause Button */
		public var pause_btn:MovieClip;
		/** Full screen Button */
		public var fullScreen_btn:MovieClip;
		/** Follow Button */
		public var follow_btn:MovieClip;
		
		/** Relation between width and height to keep ratio on resizing video */
		public var relationship:Number;
		
		/** Instance from video class */
		private var vid:Video = new Video();
		
		/** Variable to hold stage current width */
		private var _stageW:int;
		/** Variable to hold stage current height */
		private var _stageH:int;;
		
		/** Variable to hold video current width */
		private var _videoW:int;
		/** Variable to hold video current width */
		private var _videoH:int;
		
		/** PlayerView class constructor  */
		public function PlayerView(player:Player) {
			
			_player = player;
			
			_player.addEventListener(Player.ASSETS_LOADED, assetsReady);
			_player.addEventListener(Player.SCREEN_RESIZED, screenResized);
			_player.addEventListener(Player.META_RECEIVED, metaReceived);
		}
		
		/**add video and buttons once metadata for the stream received */
		private function metaReceived(event:Event):void
		{
			_stageW = stage.stageWidth;
			_stageH = stage.stageHeight;
						
			relationship = _player.metaDara.height / _player.metaDara.width;
			
			addChild(vid);
			addChild(play_btn);
			addChild(pause_btn);
			addChild(fullScreen_btn);
			
			play_btn.visible = false;
			
			normalVideoSize();
			
			vid.attachNetStream(_player.netStreamObj);
		}
		
		/** Trigger screen resize event */
		private function screenResized(event:Event):void
		{
			if(_player.screenState == "full")
			fullVideoSize();
			else if (_player.screenState == "normal")
			normalVideoSize();
		}
		
		/** once assets loaded apply the skin to buttons */
		private function assetsReady(event:Event):void
		{
			play_btn = new _player.PlayButtonClass() as MovieClip;			
			pause_btn = new _player.PauseButtonClass() as MovieClip;			
			fullScreen_btn = new _player.FullScreenButtonClass() as MovieClip;			
			follow_btn = new _player.FollowButtonClass() as MovieClip;

			addChild(follow_btn);
			follow_btn.x = 20;
			follow_btn.y = 20;
		}
		
		/** Change assets size and position to fit full screen mode */
		private function fullVideoSize():void
		{
			_stageW = stage.stageWidth;
			_stageH = stage.stageHeight;
			
			_videoW = _stageW;
			_videoH = _videoW * relationship;

			vid.width = _videoW;
			vid.height = _videoH;
			
			vid.x = _stageW/2 - vid.width/2;
			vid.y = _stageH / 2 - vid.height / 2;
			
			play_btn.x = 20;
			pause_btn.x = 20;
			fullScreen_btn.x = _stageW - 50;
			
			pause_btn.y = _stageH - 70;
			play_btn.y = _stageH - 70;
			fullScreen_btn.y = _stageH - 70;
		}
		
		/** Change assets size and position back to normal screen mode */
		private function normalVideoSize():void
		{
			_stageW = stage.stageWidth;
			_stageH = stage.stageHeight;

			_videoW = 600;
			_videoH = _videoW * relationship;
			
			vid.width = _videoW;
			vid.height = _videoH;
			
			vid.x = _stageW/2 - vid.width/2;
			vid.y = _stageH/2 - vid.height/2;
			
			play_btn.x = _stageW/2 - vid.width/2 ;
			pause_btn.x = _stageW/2 - vid.width/2;
			fullScreen_btn.x = _stageW/2 - vid.width/2 + 570;
			
			pause_btn.y = _stageH/2 + vid.height / 2 +10;
			play_btn.y = _stageH/2 + vid.height / 2 +10;
			fullScreen_btn.y = _stageH/2 + vid.height / 2 +10;
		}
	}
}
