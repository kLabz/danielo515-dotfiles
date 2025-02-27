package vim;

import lua.NativeStringTools;

@:arrayAccess
abstract LuaArray<T>(lua.Table<Int, T>) from lua.Table<Int, T> to lua.Table<Int, T> {
	// Can this be converted into a macro to avoid even calling fromArray ?
	@:from
	public static function from<T>(arr:Array<T>):LuaArray<T> {
		return lua.Table.fromArray(arr);
	}
}

@:forward // automatically get fields from underlying type
abstract LuaObj<T>(T) {
	@:from
	public static inline function fromType<T>(obj:T):LuaObj<T> {
		@:nullSafety(Off) untyped obj.__fields__ = null;
		@:nullSafety(Off) lua.Lua.setmetatable(cast obj, null);
		return cast obj;
	}

	// could add a @:from lua table, but that will automatically accept/convert any lua table, probably want to make it explicit

	@:to
	public function to():lua.Table<String, Dynamic> {
		return cast this;
	}
}

// Some boilerplate here for type safety
abstract BufferId(Int) from Int {
	public function new(buf:Int) {
		this = buf;
	}

	@:from
	public static inline function from(bufNum:Int):BufferId {
		return new BufferId(bufNum);
	}
}

abstract WindowId(Int) from Int {
	public function new(id:Int) {
		this = id;
	}

	@:from
	public static inline function from(id:Int):WindowId {
		return new WindowId(id);
	}
}

enum abstract VimEvent(String) {
	final BufNewFile; // starting to edit a file that doesn't exist
	final BufReadPre; // starting to edit a new buffer, before reading the file
	final BufRead; // starting to edit a new buffer, after reading the file
	final BufReadPost; // starting to edit a new buffer, after reading the file
	final BufReadCmd; // before starting to edit a new buffer Cmd-event
	final FileReadPre; // before reading a file with a ":read" command
	final FileReadPost; // after reading a file with a ":read" command
	final FileReadCmd; // before reading a file with a ":read" command Cmd-event
	final FilterReadPre; // before reading a file from a filter command
	final FilterReadPost; // after reading a file from a filter command
	final StdinReadPre; // before reading from stdin into the buffer
	final StdinReadPost; // After reading from the stdin into the buffer
	final BufAdd; // just after adding a buffer to the buffer list
	final BufCreate; // just after adding a buffer to the buffer list
	final BufDelete; // before deleting a buffer from the buffer list
	final BufWipeout; // before completely deleting a buffer
	final BufFilePre; // before changing the name of the current buffer
	final BufFilePost; // after changing the name of the current buffer
	final BufEnter; // after entering a buffer
	final BufLeave; // before leaving to another buffer
	final BufWinEnter; // after a buffer is displayed in a window
	final BufWinLeave; // before a buffer is removed from a window
	final BufUnload; // before unloading a buffer
	final BufHidden; // just after a buffer has become hidden
	final BufNew; // just after creating a new buffer
	final SwapExists; // detected an existing swap file
	final BufWrite; // starting to write the whole buffer to a file
	final BufWritePre; // starting to write the whole buffer to a file
	final BufWritePost; // after writing the whole buffer to a file
	final BufWriteCmd; // before writing the whole buffer to a file Cmd-event
	final FileWritePre; // starting to write part of a buffer to a file
	final FileWritePost; // after writing part of a buffer to a file
	final FileWriteCmd; // before writing part of a buffer to a file Cmd-event
	final FileAppendPre; // starting to append to a file
	final FileAppendPost; // after appending to a file
	final FileAppendCmd; // before appending to a file Cmd-event
	final FilterWritePre; // starting to write a file for a filter command or diff
	final FilterWritePost; // after writing a file for a filter command or diff
	final FileType; // when the 'filetype' option has been set
	final Syntax; // when the 'syntax' option has been set
	final EncodingChanged; // after the 'encoding' option has been changed
	final TermChanged; // after the value of 'term' has changed
	final FileChangedShell; // Vim notices that a file changed since editing started
	final FileChangedShellPost; // After handling a file changed since editing started
	final FileChangedRO; // before making the first change to a read-only file
	final ShellCmdPost; // after executing a shell command
	final ShellFilterPost; // after filtering with a shell command
	final FuncUndefined; // a user function is used but it isn't defined
	final SpellFileMissing; // a spell file is used but it can't be found
	final SourcePre; // before sourcing a Vim script
	final SourceCmd; // before sourcing a Vim script Cmd-event
	final VimResized; // after the Vim window size changed
	final FocusGained; // Vim got input focus
	final FocusLost; // Vim lost input focus
	final CursorHold; // the user doesn't press a key for a while
	final CursorHoldI; // the user doesn't press a key for a while in Insert mode
	final CursorMoved; // the cursor was moved in Normal mode
	final CursorMovedI; // the cursor was moved in Insert mode
	final WinEnter; // after entering another window
	final WinLeave; // before leaving a window
	final TabEnter; // after entering another tab page
	final TabLeave; // before leaving a tab page
	final CmdwinEnter; // after entering the command-line window
	final CmdwinLeave; // before leaving the command-line window
	final InsertEnter; // starting Insert mode
	final InsertChange; // when typing while in Insert or Replace mode
	final InsertLeave; // when leaving Insert mode
	final InsertCharPre; // when a character was typed in Insert mode, before inserting it
	final TextChanged; // after a change was made to the text in Normal mode
	final TextChangedI; // after a change was made to the text in Insert mode
	final ColorScheme; // after loading a color scheme
	final RemoteReply; // a reply from a server Vim was received
	final QuickFixCmdPre; // before a quickfix command is run
	final QuickFixCmdPost; // after a quickfix command is run
	final SessionLoadPost; // after loading a session file
	final MenuPopup; // just before showing the popup menu
	final CompleteDone; // after Insert mode completion is done
	final User; // to be used in combination with ":doautocmd"
	final VimEnter; // after doing all the startup stuff
	final GUIEnter; // after starting the GUI successfully
	final GUIFailed; // after starting the GUI failed
	final TermResponse; // after the terminal response to t_RV is received
	final QuitPre; // when using :quit, before deciding whether to quit
	final VimLeavePre; // before exiting Vim, before writing the viminfo file
	final VimLeave; // before exiting Vim, after writing the viminfo file
}

// Yes, it is intentional that you can not create this from a string
enum abstract PathModifier(String) to String {
	final FullPath = ":p";
	final Head = ":h";
	final Tail = ":t";
}

enum abstract VimRef(String) to String {
	final CurentFile = "%";
}

abstract ExpandString(String) from VimRef {
	public inline function new(path:VimRef) {
		this = path;
	}

	@:from
	public static inline function from(ref:VimRef) {
		return new ExpandString(ref);
	}

	@:op(A + B) public inline function plus0(modifiers:PathModifier):ExpandString {
		return cast NativeStringTools.format("%s%s", this, modifiers);
	}

	@:op(A + B) public static inline function plus(path:ExpandString, modifiers:PathModifier):ExpandString {
		return cast NativeStringTools.format("%s%s", path, modifiers);
	}
}
