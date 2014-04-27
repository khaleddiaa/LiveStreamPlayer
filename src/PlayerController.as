package  
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	public class PlayerController 
	{
		/** variable to hold Player instance that passed at constructor */
		private var _player:Player;
		/** variable to hold PlayerView instance that passed at constructor */
		private var _playerView:PlayerView;
		
		/** PlayerController class constructor  */
		public function PlayerController(player:Player,view:PlayerView) 
		{
			/** hold Player class instance in _player variable */
			_player = player;
			/** hold PlayerView class instance in _playerView variable */
			_playerView = view;
			/** adding event listener called once player assets are loaded*/
			_player.addEventListener(Player.ASSETS_LOADED, assetsReady);
			/** adding event listener called once player assets are loaded*/
			ExternalInterface.addCallback("requestResult", requestResult);
		}
		
		/** add eventlisteners to all needed buttons once their assets loaded */
		private function assetsReady(event:Event):void
		{
			_playerView.play_btn.addEventListener(MouseEvent.CLICK, playStream);
			_playerView.pause_btn.addEventListener(MouseEvent.CLICK, pauseStream);
			_playerView.fullScreen_btn.addEventListener(MouseEvent.CLICK, fullScreen);
			_playerView.follow_btn.addEventListener(MouseEvent.CLICK, followClick);
			_playerView.follow_btn.addEventListener(MouseEvent.MOUSE_OVER, followHover);
			_playerView.follow_btn.addEventListener(MouseEvent.MOUSE_OUT, followOut);
		}
		
		/** This method is called from javascript once request succeed */
		private function requestResult(status:String):void 
		{
			if(status=="follow_success")
			_playerView.follow_btn.gotoAndStop(2);
			else if (status == "unfollow_success")
			_playerView.follow_btn.gotoAndStop(1);
		}
		
		/**play steam video ,tirgger play button click*/
		private function playStream(event:MouseEvent):void
		{
		    _player.netStreamObj.resume();
			_playerView.play_btn.visible = false;
			_playerView.play_btn.visible = true;
		}
		
		/**pause steam video ,tirgger play button click*/
		private function pauseStream(event:MouseEvent):void
		{
			_player.netStreamObj.pause();
			_playerView.play_btn.visible = true;
			_playerView.play_btn.visible = false;
		}
		
		/** Trigger hover up follow button with mouse */
		private function followHover(event:MouseEvent):void
		{
			if (event.target.currentFrame == 2)
			event.target.gotoAndStop(3);
		}
		
		/** Trigger hover out follow button with mouse */
		private function followOut(event:MouseEvent):void
		{
			if (event.target.currentFrame == 3)
			event.target.gotoAndStop(2);
		}
		
		/** Trigger click follow button with mouse */
		private function followClick(event:MouseEvent):void
		{
			if (event.target.currentFrame == 1)
			ExternalInterface.call("followUser");
			else if (event.target.currentFrame == 3)
			ExternalInterface.call("unfollowUser");
		}
		
		/**Full screen toggle function ,trigger full screen button click*/
		private function fullScreen(event:MouseEvent):void
		{
			if(_player.screenState == "normal")
			_player.screenState = "full";
			else if (_player.screenState == "full")
			_player.screenState = "normal";
		}
	}
	
}
