package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class WarningSubState extends MusicBeatState 
{
    var bg:FlxSprite;

    override function create()
    {
        super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"!! VERY IMPORTANT DISCLAIMER !!\n\n" +
            "This mod makes use of Lua modcharts that creates flashing lights\n" +
            "and shaky notefields, which can trigger epilepsy, seizures,\n" +
            "motion sickness, etc. to people suffering illnesses that has\n" +
            "these symptoms.\n\n" +
            "If you feel unwell or is currently suffering these kinds of illnesses\n" +
            "and still wish to play this mod, please press ENTER in this state or manually go to \n" +
            "options to disable the modcharts. If you wish to proceed normally, press the ESCAPE key.\n" +
            "\nYOUR SAFETY MATTERS FIRST!\n", 
			32);
		txt.setFormat("VCR OSD Mono", 26, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
    }
    override function update(elapsed:Float)
        {
            if (controls.ACCEPT)
            {
                FlxG.sound.play(Paths.sound('confirmMenu'), 0.5);
                EngineData.options.loadModcharts = false;
                EngineData.options.saveOptions();
                FlxG.switchState(new MainMenuState());
            }
            if (controls.BACK)
            {
                FlxG.switchState(new MainMenuState());
            }
            
            super.update(elapsed);
        }
}