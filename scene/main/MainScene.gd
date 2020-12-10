extends "res://library/RootNodeTemplate.gd"


const INIT_WORLD: String = "InitWorld"
const PC_MOVE: String = "PCMove"
const PC_ATTACK: String = "PCMove/PCAttack"
const NPC: String = "EnemyAI"
const SCHEDULE: String = "Schedule"
const DUNGEON: String = "DungeonBoard"
const REMOVE: String = "RemoveObject"
const SIDEBAR: String = "CanvasLayer/MainGUI/MainHBox/SidebarVBox"
const MODELINE: String = "CanvasLayer/MainGUI/MainHBox/Modeline"
const PAUSE_MENU: String = "CanvasLayer/MainGUI/PauseMenu"
const PAUSE_MANAGER: String = "PauseManager"
const ENEMY_AS: String = "EnemyAI/EnemyAS"
const ENEMY_ATTACK: String = "EnemyAI/EnemyAttack"
const FOV: String = "PCMove/FOV"
const ITEM_MANAGER: String = "ItemManager"
const SAVE_LOAD_MANAGER: String = "SaveLoadManager"
const DUNGEON_SIZE: String = "DungeonSize"

const SIGNAL_BIND: Array = [
	[
		"sprite_created", "_on_InitWorld_sprite_created",
		INIT_WORLD,
		PC_MOVE, NPC, SCHEDULE, DUNGEON, FOV,PAUSE_MANAGER,
	],
	[
		"turn_started", "_on_Schedule_turn_started",
		SCHEDULE,
		PC_MOVE, NPC, SIDEBAR,
	],
	[
		"turn_ended", "_on_Schedule_turn_ended",
		SCHEDULE,
		MODELINE,
	],
	[
		"sprite_removed", "_on_RemoveObject_sprite_removed",
		REMOVE,
		DUNGEON, SCHEDULE,
	],	
	[
		"pc_moved_board","_on_PCMove_pc_moved_board",
		PC_MOVE,
		DUNGEON,FOV,
	],
	[
		"enemy_moved_board","_on_EnemyAI_enemy_moved_board",
		NPC,
		DUNGEON,
	],
	[
		"enemy_warned", "_on_EnemyAI_enemy_warned",
		NPC,
		MODELINE,
	],	
	[
		"enemy_attacked", "_on_EnemyAttack_enemy_attacked",
		ENEMY_ATTACK,
		MODELINE,
	],
	[
		"pc_moved", "_on_PCMove_pc_moved",
		PC_MOVE,
		MODELINE,
	],
	[
		"pc_attacked", "_on_PCAttack_pc_attacked",
		PC_ATTACK,
		MODELINE,FOV,
	],
	[
		"pc_moved_board","_on_SaveLoadManager_pc_moved_board",
		SAVE_LOAD_MANAGER,
		DUNGEON,FOV,
	],
	[
		"load_game","_on_SaveLoadManager_load_game",
		SAVE_LOAD_MANAGER,
		MODELINE,SIDEBAR,PAUSE_MENU,
	],	
	[
		"restart","_on_PCMove_restart",
		PAUSE_MANAGER,
		SIDEBAR,MODELINE,
	],
	[
		"level_changed","_on_InitWorld_level_changed",
		INIT_WORLD,
		SCHEDULE,
	],
]

const NODE_REF: Array = [
	[
		"_ref_DungeonBoard",
		DUNGEON,
		PC_MOVE, PC_ATTACK, REMOVE, INIT_WORLD, ENEMY_AS, ENEMY_ATTACK, NPC, FOV,SAVE_LOAD_MANAGER,
	],
	[
		"_ref_Schedule",
		SCHEDULE,
		PC_MOVE, NPC, PC_ATTACK, ENEMY_ATTACK,SAVE_LOAD_MANAGER,
	],
	[
		"_ref_RemoveObject",
		REMOVE,
		PC_ATTACK, ENEMY_ATTACK, ITEM_MANAGER,SAVE_LOAD_MANAGER,PC_MOVE,
	],
	[
		"_ref_FOV",
		FOV,
		INIT_WORLD,NPC,
	],	
	[
		"_ref_ItemManager",
		ITEM_MANAGER,
		PC_MOVE,
	],	
	[
		"_ref_PauseMenu",
		PAUSE_MENU,
		PC_MOVE,PAUSE_MANAGER,
	],
	[
		"_ref_InitWorld",
		INIT_WORLD,
		SAVE_LOAD_MANAGER,PC_MOVE,PC_ATTACK,PAUSE_MANAGER,
	],
	[
		"_ref_SaveLoadManager",
		SAVE_LOAD_MANAGER,
		PAUSE_MENU,
	],	
	[
		"_ref_Sidebar",
		SIDEBAR,
		SAVE_LOAD_MANAGER,
	],
	[
		"_ref_PCMove",
		PC_MOVE,
		ENEMY_ATTACK,
	],
	
	[
		"_ref_DungeonSize",
		DUNGEON_SIZE,
		INIT_WORLD,FOV,DUNGEON,SAVE_LOAD_MANAGER,PC_MOVE,PAUSE_MANAGER,
	],
	[
		"_ref_PauseManager",
		PAUSE_MANAGER,
		PC_MOVE,
	],
	
]


func _init().(SIGNAL_BIND, NODE_REF) -> void:
	pass
