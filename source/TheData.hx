package;

import flixel.FlxG;

class TheData 
{
    //Copy-paste of Kade Engine (kade, dont kill me)
    public static function saveLoad() 
    {
        if(FlxG.save.data.newInput == null)
            FlxG.save.data.newInput = true;
    
        if(FlxG.save.data.downscroll == null)
            FlxG.save.data.downscroll = false;

        if(FlxG.save.data.cpuStrums == null)
            FlxG.save.data.cpuStrums = false;

        if(FlxG.save.data.colour == null)
            FlxG.save.data.colour = true;
    
        if(FlxG.save.data.betterIcons == null)
            FlxG.save.data.betterIcons = true;

        if(FlxG.save.data.flashing == null)
            FlxG.save.data.flashing = true;

        if(FlxG.save.data.health == null)
            FlxG.save.data.health = false;
        
        if(FlxG.save.data.botplay == null)
            FlxG.save.data.botplay = false;

        if(FlxG.save.data.resetButton == null)
            FlxG.save.data.resetButton = false;

        if(FlxG.save.data.skip == null)
            FlxG.save.data.skip = true;

        if(FlxG.save.data.songPosition == null)
            FlxG.save.data.songPosition = false;
        
        if(FlxG.save.data.remix == null)
            FlxG.save.data.remix = true;
    }

    public static function resetSave()
    {
        FlxG.save.data.newInput == null;
        FlxG.save.data.downscroll == null;
        FlxG.save.data.cpuStrums == null;
        FlxG.save.data.colour == null;
        FlxG.save.data.betterIcons == null;
        FlxG.save.data.flashing == null;
        FlxG.save.data.health == null;
        FlxG.save.data.botplay == null;
        FlxG.save.data.resetButton == null;
        FlxG.save.data.skip == null;
        FlxG.save.data.songPosition == null;
        FlxG.save.data.remix == null;

        saveLoad();
    }
}