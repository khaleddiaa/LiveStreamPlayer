package  
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	
	public class Main extends MovieClip
	{
		/** Create Instance from Player Class*/
		private var player:Player;
		/** Create Instance from PlayerView Class*/
		private var view:PlayerView;
		/** Create Instance from PlayerController Class*/
		private var controller:PlayerController;
		/**Main Class constructor */
		public function Main()
		{
			if (stage)
			addPlayer();
            else
			addEventListener(Event.ADDED_TO_STAGE, addPlayer);
		}	
		
		/** create video player and add it to stage */
		private function addPlayer(e:Event=null):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var flashVars:Object = this.root.loaderInfo.parameters;
			var vidStream:String = flashVars["stream"];
			var vidUrl:String = flashVars["url"];
			
			player = new Player(stage,vidStream,vidUrl);
			view = new PlayerView(player);
			controller = new PlayerController(player,view);
			
			addChild(view);
		}
	}
}