package;

import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var menuStuff:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options', 'donate'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	var titleText:FlxSprite;

	public static var preRelease:String = "";

	public static var versionlol:String = "0.3" + preRelease;
	public static var fnfVer:String = "v0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			if(FlxG.save.data.remix)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenuRemix'), 0);
				}
				else
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('main_menu/menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		if(FlxG.save.data.antialiasing)
			{
				bg.antialiasing = true;
			}
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('main_menu/menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		if(FlxG.save.data.antialiasing)
			{
				magenta.antialiasing = true;
			}
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();
		
		menuStuff = new FlxTypedGroup<FlxSprite>();
		add(menuStuff);

		var bf = Paths.getSparrowAtlas('mainmenu_stuff/bfMainMenu', 'shared');

		//Even tho its called "TitleText" is the bf
		titleText = new FlxSprite(100, -200);
		titleText.frames = bf;
		titleText.animation.addByPrefix('idle', "BF idle dance instancia 1", 24);
		titleText.animation.addByPrefix('pressa', "BF HEY!! instancia 1", 24);
		titleText.animation.addByPrefix('coin', "coin instancia 1", 24);
		titleText.animation.addByPrefix('freeplay', "freeplay_shit instancia 1", 24);
		titleText.animation.addByPrefix('gear', "gear instancia 1", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		//titleText.screenCenter(Y);
		menuStuff.add(titleText);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('main_menu/FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(80, FlxG.height * 1.6);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			// menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			if (firstStart)
				FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						finishedFunnyMove = true; 
					}});
			else
				menuItem.y = 60 + (i * 160);
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, fnfVer + " FNF - " + versionlol + " Anaconda Engine", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("assets/fonts/Funkin.otf", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (FlxG.keys.justPressed.F11)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		if (!selectedSomethin)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
			}

			if (FlxG.keys.justPressed.UP)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());

				FlxTween.tween(FlxG.camera, { zoom: -2}, 0.4, { ease: FlxEase.expoIn});
				FlxTween.tween(FlxG.camera, { angle: -90}, 0.4, { ease: FlxEase.expoIn});
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					epicOpenUrl("https://ninja-muffin24.itch.io/funkin");
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {x: -600}, 0.6, {
								ease: FlxEase.backIn,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									var daChoice:String = optionShit[curSelected];

									switch (daChoice)
									{
										case 'story mode':
											titleText.animation.play("pressa");
											FlxG.switchState(new StoryMenuState());
											trace("Story Menu Selected");
										case 'freeplay':
											titleText.animation.play('freeplay');
											FlxG.switchState(new FreeplayState());

											trace("Freeplay Menu Selected");

										case 'options':
											titleText.animation.play('gear');
											FlxG.switchState(new OptionsMenu());
									}
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									var daChoice:String = optionShit[curSelected];

									switch (daChoice)
									{
										case 'story mode':
											titleText.animation.play("pressa");
											FlxG.switchState(new StoryMenuState());
											trace("Story Menu Selected");
										case 'freeplay':
											titleText.animation.play('freeplay');
											FlxG.switchState(new FreeplayState());

											trace("Freeplay Menu Selected");

										case 'options':
											titleText.animation.play('gear');
											FlxG.switchState(new OptionsMenu());
									}
								});
							}
						}
					});

					menuStuff.forEach(function(spr:FlxSprite)
						{
							FlxTween.tween(spr, {y: -1000}, 0.6, {
								ease: FlxEase.backIn,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				var daChoice:String = optionShit[curSelected];
				spr.animation.play('selected');
				
				switch (daChoice)
				{
					case 'story mode':
						titleText.animation.play('idle');
					case 'freeplay':
						titleText.animation.play('freeplay');
					case 'options':
						titleText.animation.play('gear');
					case 'donate':
						titleText.animation.play('coin');
				}
				//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}