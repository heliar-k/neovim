local rust_server = {
	["rust-analyzer"] = {
		standalone = true,
		checkOnSave = {
			command = "clippy",
		},
		files = {
			excludeDirs = {
				".flatpak-builder",
				"_build",
				".dart_tool",
				".flatpak-builder",
				".git",
				".gitlab",
				".gitlab-ci",
				".gradle",
				".idea",
				".next",
				".project",
				".scannerwork",
				".settings",
				".venv",
				"archetype-resources",
				"bin",
				"docs",
				"hooks",
				"node_modules",
				"po",
				"screenshots",
				"target",
				"out",
				"examples/node_modules",
				"../out",
				"../node_modules",
				"../.next",
			},
		},
	},
	procMacro = {
		enable = true,
		ignored = {
			["async-trait"] = { "async_trait" },
			["napi-derive"] = { "napi" },
			["async-recursion"] = { "async_recursion" },
		},
	},
}

vim.g.rustaceanvim = function()
	local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
	local codelldb_path = codelldb_root .. "adapter/codelldb"
	local liblldb_name
	local system_name = vim.loop.os_uname().sysname
	if system_name:match("Windows") then
		liblldb_name = "liblldb.dll"
	elseif system_name:match("Darwin") then
		liblldb_name = "liblldb.dylib"
	else
		liblldb_name = "liblldb.so"
	end
	local liblldb_path = codelldb_root .. "lldb/lib/" .. liblldb_name
	local cfg = require("rustaceanvim.config")
	return {
		tools = {},
		server = rust_server,
		dap = {
			adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
		},
	}
end
