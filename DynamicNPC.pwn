#include <a_samp>
#include <zcmd> // Source : https://github.com/Southclaws/zcmd

// COLOR // UNTUK WARNA SENDCLIENTMESSAGE
#define COLOR_RED 0xFF4500AA
#define COLOR_BLUE 0x4169FFAA

// VARIABLE
new DynamicNPCMod[MAX_PLAYERS];
new DynamicNPCCreatd[MAX_PLAYERS];

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
}

#endif

public OnPlayerConnect(playerid)
{
    DynamicNPCCreatd[playerid] = 0;
    DynamicNPCMod[playerid] = 0;
	return 1;
}

// COMMANDS
CMD:createnpc(playerid, params)
{
	if(!IsPlayerAdmin(playerid))
	{
		SendClientMessage(playerid,COLOR_RED,"ERROR: ANDA HARUS LOGIN RCON TERLEBIH DAHULU MAMEN!");
		return 1;
	}
	else if(DynamicNPCMod[playerid] == 1)
	{
 		SendClientMessage(playerid,COLOR_RED,"ERROR: Anda sudah membuat NPC!"); // INI LIMIT BUAT PEMBUATAN NPCNYA
	}
	else
	{
		DynamicNPCMod[playerid] = 1;
		ShowPlayerDialog(playerid,1020,DIALOG_STYLE_MSGBOX,"Pembuatan NPC","Ikuti langkah-langkah untuk membuat NPC Anda!","OK","Exit");
	}
	return 1;
}

CMD:destroynpc(playerid, params)
{
	if(!IsPlayerAdmin(playerid))
	{
		SendClientMessage(playerid,COLOR_RED,"ERROR: ANDA HARUS LOGIN RCON TERLEBIH DAHULU MAMEN");
		return 1;
	}
	if(DynamicNPCCreatd[playerid] == 0)
 	{
		return 1;
 	}
  	else if(DynamicNPCCreatd[playerid] == 1)
  	{
	   	ShowPlayerDialog(playerid,1025,DIALOG_STYLE_MSGBOX,"Pembuatan NPC (Selesai):","Anda membuat NPC Anda! Klik Done!","Done","");
	   	StopRecordingPlayerData(playerid);
 		DynamicNPCCreatd[playerid] = 0;
	}
	return 1;
}

// CALLBACKS
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid == 1020)
	{
	case 1:
		{
		    if(response)
		    {
		        ShowPlayerDialog(playerid,1021,DIALOG_STYLE_MSGBOX,"Pembuatan NPC (Step 1 - Mode / Status):","Pilih Salah Satu Pilihan di bawah!","Jalan Kaki","Di Kendaraan");
		    }
		    else
		    {
		        DynamicNPCMod[playerid] = 0;
		        SendClientMessage(playerid,COLOR_RED,"Anda telah keluar dari mode NPC Create!");
			}
		}
	}
	switch(dialogid == 1021)
	{
	case 1:
	    {
	        if(response)
	        {
	            ShowPlayerDialog(playerid,1022,DIALOG_STYLE_INPUT,"Pembuatan NPC (Step 2 - Pembuatan Skin):","Masukan id skin untuk NPC Anda!!","Set","Exit");
			}
			else
		    {
		        ShowPlayerDialog(playerid,1026,DIALOG_STYLE_INPUT,"Pembuatan NPC (Step 2 - Pembuatan Skin):","Masukan id skin untuk NPC Anda!!","Set","Exit");
			}
		}
	}
	switch(dialogid == 1022)
	{
	case 1:
	    {
	        if(response)
	        {
	            new tmp[256];
				new idx;
			    tmp = strtok(inputtext, idx);
			    new skin = strval(tmp);
			    if(skin < 0 || skin > 289)
	    		{
	    		    SetPlayerSkin(playerid,skin);
	            	ShowPlayerDialog(playerid,1022,DIALOG_STYLE_INPUT,"Pembuatan NPC (Step 2 - Pembuatan Skin):","Goblok!, coba lu lihat di script id skin limit di id berapa!!","Set","Exit");
				}
				else
	    		{
	  		  		SetPlayerSkin(playerid,skin);
	   		   		ShowPlayerDialog(playerid,1023,DIALOG_STYLE_MSGBOX,"Pembuatan NPC (Step 3 - Pembuatan File):","Buat File .pwn","Create","Exit");
				}
			}
            else
		    {
		        DynamicNPCMod[playerid] = 0;
		        SendClientMessage(playerid,COLOR_RED,"Anda telah keluar dari mode NPC Create!");
			}
		}
	}
	switch(dialogid == 1026)
	{
	case 1:
	    {
	        if(response)
	        {
	            new tmp[256];
				new idx;
			    tmp = strtok(inputtext, idx);
			    new skin = strval(tmp);
			    if(skin < 0 || skin > 289)
	    		{
	    		    SetPlayerSkin(playerid,skin);
	            	ShowPlayerDialog(playerid,1026,DIALOG_STYLE_INPUT,"Pembuatan NPC (Step 2 - Pembuatan Skin):","Goblok!, coba lu lihat di script id skin limit di id berapa!!","Set","Exit");
				}
				else
	    		{
	  		  		SetPlayerSkin(playerid,skin);
	   		   		ShowPlayerDialog(playerid,1027,DIALOG_STYLE_MSGBOX,"Pembuatan NPC (Step 3 - Pembuatan File):","Buat File .pwn","Create","Exit");
				}
			}
            else
		    {
		        DynamicNPCMod[playerid] = 0;
		        SendClientMessage(playerid,COLOR_RED,"Anda telah keluar dari mode NPC Create!");
			}
		}
	}
	switch(dialogid == 1023)
	{
	case 1:
	    {
	        if(response)
	        {
	            new scriptstring[456];
	       		new namestring[256];
	       		format(scriptstring,sizeof(scriptstring),"#include <a_npc>\n#define NPC NpcPlayback\n\nNextPlayBack()\n{\n	StartRecordingPlayback(PLAYER_RECORDING_TYPE_ONFOOT,NPC);\n}\n\npublic OnRecordingPlaybackEnd()\n{\n	NextPlayBack();\n}\npublic OnNPCSpawn()\n{\n\tNextPlayBack();\n\n\tSetPlayerSkin(playerid,%s);\n}\npublic OnNPCExitVehicle()\n{\n	StopRecordingPlayback();\n}");
	       		format(namestring,sizeof(namestring),"kazujidynamicnpc.pwn");
	       		new File: PwnFile;
	       		PwnFile = fopen(namestring,io_write);
	       		fwrite(PwnFile,scriptstring);
	       		fclose(PwnFile);
        		ShowPlayerDialog(playerid,1024,DIALOG_STYLE_INPUT,"Pembuatan NPC (Step 4 - Nama File Save):","Masukan nama buat npc lu terserah","Name","Exit");
			}
            else
		    {
		        DynamicNPCMod[playerid] = 0;
		        SendClientMessage(playerid,COLOR_RED,"Anda telah keluar dari mode NPC Create!");
			}
		}
	}
	switch(dialogid == 1027)
	{
	case 1:
	    {
	        if(response)
	        {
	            new scriptstring[456];
	       		new namestring[256];
	       		format(scriptstring,sizeof(scriptstring),"#include <a_npc>\n#define NPC NpcPlayback\n\nNextPlayBack()\n{\n	StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,NPC);\n}\n\npublic OnRecordingPlaybackEnd()\n{\n	NextPlayBack();\n}\npublic OnNPCSpawn()\n{\n\tNextPlayBack();\n\n\tSetPlayerSkin(playerid,%s);\n}\npublic OnNPCExitVehicle()\n{\n	StopRecordingPlayback();\n}");
	       		format(namestring,sizeof(namestring),"kazujidynamicnpc.pwn");
	       		new File: PwnFile;
	       		PwnFile = fopen(namestring,io_write);
	       		fwrite(PwnFile,scriptstring);
	       		fclose(PwnFile);
        		ShowPlayerDialog(playerid,1028,DIALOG_STYLE_INPUT,"Pembuatan NPC (Step 4 - Nama File Save):","Masukan nama buat npc lu terserah","Name","Exit");
			}
            else
		    {
		        DynamicNPCMod[playerid] = 0;
		        SendClientMessage(playerid,COLOR_RED,"Anda telah keluar dari mode NPC Create!");
			}
		}
	}
	switch(dialogid == 1024)
	{
	case 1:
	    {
	        if(response)
	        {
	         	if(!strlen(inputtext))
		    	{
					ShowPlayerDialog(playerid,1024,DIALOG_STYLE_INPUT,"Pembuatan NPC (Step 4 - Nama File Save):","Masukan nama buat npc lu terserah","Name","Exit");
				}
		    	else
		    	{
		            new scriptstring[456];
	        		new namestring[256];
	        		format(scriptstring,sizeof(scriptstring),"#include <a_npc>\n#define NPC NpcPlayback\n\nNextPlayBack()\n{\n	StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,NPC);\n}\n\npublic OnRecordingPlaybackEnd()\n{\n	NextPlayBack();\n}\npublic OnNPCSpawn()\n{\n\tNextPlayBack();\n}\npublic OnNPCExitVehicle()\n{\n	StopRecordingPlayback();\n}");
	        		format(namestring,sizeof(namestring),"kazujidynamicnpc.pwn");
	        		new File: PwnFile;
	        		PwnFile = fopen(namestring,io_write);
	        		fwrite(PwnFile,scriptstring);
	        		fclose(PwnFile);
		    	    DynamicNPCCreatd[playerid] = 1;
		    	    SendClientMessage(playerid,COLOR_BLUE,"Skrip dimulai! Ketik /destroynpc untuk berhenti!");
		    	    StartRecordingPlayerData(playerid,PLAYER_RECORDING_TYPE_ONFOOT,inputtext);
				}
			}
			else
		    {
		        DynamicNPCMod[playerid] = 0;
		        SendClientMessage(playerid,COLOR_RED,"Anda telah keluar dari mode NPC Create!");
			}
		}
	}
	switch(dialogid == 1028)
	{
	case 1:
	    {
	        if(response)
	        {
	         	if(!strlen(inputtext))
		    	{
					ShowPlayerDialog(playerid,1028,DIALOG_STYLE_INPUT,"Pembuatan NPC (Step 4 - Nama File Save):","Masukan nama buat npc lu terserah","Name","Exit");
				}
		    	else
		    	{
		    	    new NPCar;
					new Float:X,Float:Y,Float:Z,Float:Angle;
					GetPlayerPos(playerid,X,Y,Z);
					GetPlayerFacingAngle(playerid,Angle);
					NPCar = CreateVehicle(411,X,Y,Z,Angle,0,0,0);
					PutPlayerInVehicle(playerid,NPCar,0);
		            new scriptstring[456];
	        		new namestring[256];
	        		format(scriptstring,sizeof(scriptstring),"#include <a_npc>\n#define NPC NpcPlayback\n\nNextPlayBack()\n{\n	StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER,NPC);\n}\n\npublic OnRecordingPlaybackEnd()\n{\n	NextPlayBack();\n}\npublic OnNPCSpawn()\n{\n\tNextPlayBack();\n}\npublic OnNPCExitVehicle()\n{\n	StopRecordingPlayback();\n}");
	        		format(namestring,sizeof(namestring),"mynpc.pwn");
	        		new File: PwnFile;
	        		PwnFile = fopen(namestring,io_write);
	        		fwrite(PwnFile,scriptstring);
	        		fclose(PwnFile);
		    	    DynamicNPCCreatd[playerid] = 1;
		    	    SendClientMessage(playerid,COLOR_BLUE,"Skrip dimulai! Ketik /destroynpc untuk berhenti!");
		    	    StartRecordingPlayerData(playerid,PLAYER_RECORDING_TYPE_DRIVER,inputtext);
				}
			}
			else
		    {
		        DynamicNPCMod[playerid] = 0;
		        SendClientMessage(playerid,COLOR_RED,"Anda telah keluar dari mode NPC Create!");
			}
		}
	}
	switch(dialogid == 1025)
	{
	case 1:
	    {
	        if(response)
	        {
	      		DynamicNPCMod[playerid] = 0;
	       		SendClientMessage(playerid,COLOR_BLUE,"NPC berhasil dibuat!");
	        	SendClientMessage(playerid,COLOR_BLUE,"Untuk membuat NPC lain, gunakan /createnpc!");
			}
		}
	}
	return 1;
}

// FUNCTION
stock strtok(const string[], &index,seperator=' ')
{
	new length = strlen(string);
	new offset = index;
	new result[128];
	while ((index < length) && (string[index] != seperator) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}

	result[index - offset] = EOS;
	if ((index < length) && (string[index] == seperator))
	{
		index++;
	}
	return result;
}
