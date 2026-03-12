package;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		#if debug
		if (FlxG.keys.justPressed.SEVEN)
		{
			doFileConversion();
		}
		#end
	}
	#if debug
	function doFileConversion():Void
	{
		if (!FileSystem.exists("script.tsv"))
		{
			FlxG.log.error("No script found! Place \"script.tsv\" into your main folder.");
			return;
		}
		var dialogueData:Array<Array<Array<String>>> = [];

		var content = sys.io.File.getContent("script.tsv");
		var lines = content.split("\n");
		for (line in lines)
		{
			var fields = line.split("\t");

			if (fields[0] == "dialogue")
			{
				var sent:Bool = false;

				for (i in dialogueData)
				{
					if (!sent && i[0][1] + i[0][2] == fields[1] + fields[2])
					{
						i.push(fields);
						sent = true;
					}
				}
				if (!sent)
				{
					dialogueData.push([fields]);
				}
			}
		}
		for (dialogueFile in 0...dialogueData.length)
		{
			var trueData:Array<DialogueData> = [];
			for (dialogueLine in dialogueData[dialogueFile])
			{
				var data:DialogueData = {
					dialogue: dialogueLine[6],
					actor: dialogueLine[3] ?? "",
					speed: Std.parseFloat(dialogueLine[5]),
					portrait: dialogueLine[4],
					autoSkip: false,
					continueLine: false,
					diaPitch: 0,
					voiceLine: '',
					events: []
				};

				trueData.push(data);
			}
			var filePath = "outputtedDialogue/dialogue/" + dialogueData[dialogueFile][0][1];
			var fileName = filePath + dialogueData[dialogueFile][0][2] + ".json";
			var jsonString = Json.stringify(trueData, null, "\t");

			if (!FileSystem.exists(filePath))
				FileSystem.createDirectory(filePath);
			sys.io.File.saveContent(fileName, jsonString);
		}
	}
	#end
}