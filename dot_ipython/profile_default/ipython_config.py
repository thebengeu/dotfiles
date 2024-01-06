c = get_config()
c.InteractiveShell.ast_node_interactivity = "last_expr_or_assign"
c.InteractiveShellApp.exec_lines = [
    "%autoreload 2",
]
c.InteractiveShellApp.extensions = [
    "autoreload",
    "rich",
]
c.TerminalIPythonApp.display_banner = False
c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.editing_mode = "vi"
c.TerminalInteractiveShell.prompt_includes_vi_mode = False
